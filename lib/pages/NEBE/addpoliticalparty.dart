import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:e_voting/pages/NEBE/political_party_list.dart';
import 'package:e_voting/pages/NEBE/pp.dart';
import 'package:e_voting/pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class addpoliticalparty extends StatefulWidget {
  const addpoliticalparty({super.key});

  @override
  State<addpoliticalparty> createState() => _AddPoliticalPartyState();
}

class _AddPoliticalPartyState extends State<addpoliticalparty> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  XFile? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = pickedFile;
    });
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate() && _image != null) {
      print(loginPage.apiUrl);
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("${loginPage.apiUrl}registerpoliticalparty"),
      );

      String generateCustomId() {
        final random = Random();
        const chars = '0123456789';
        return List.generate(4, (index) => chars[random.nextInt(chars.length)]).join();
      }

      String uniqueId = "PP" + generateCustomId();
      request.fields['ID'] = uniqueId;
      request.fields['name'] = _name;
      request.fields['email'] = _email;
      request.fields['password'] = _password;
      request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

      try {
        final response = await request.send();

        if (response.statusCode == 201) {
          // Display success message with party information
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: "You successfully registered the political party.\n\n"
                "User Id :$uniqueId\n Party Name: $_name\nEmail: $_email\n"
                "Password : $_password",
          );
          await Future.delayed(Duration(seconds: 5));
          Navigator.push(context, MaterialPageRoute(builder: (context) => PoliticalPartyList()));
        } else {
          final responseBody = await http.Response.fromStream(response);
          final Map<String, dynamic> responseData = json.decode(responseBody.body);
          showError(responseData['message'] ?? 'Failed to register party.');
        }
      } catch (error) {
        showError('An error occurred: $error');
      }
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: "Please import an image.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 50,
                width: 340,
                color: Colors.green,
                child: Center(
                  child: Text(
                    "Register Political Party",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) => _name = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (value) => _email = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                onChanged: (value) => _password = value,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              _image != null ? Image.file(File(_image!.path)) : Container(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerUser,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}