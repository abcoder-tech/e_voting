import 'dart:convert';
import 'dart:io';
import 'package:e_voting/pages/political_party_list.dart';
import 'package:e_voting/pages/loginpage.dart';
import 'package:e_voting/pages/pp.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

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

      request.fields['name'] = _name;
      request.fields['email'] = _email;
      request.fields['password'] = _password;
      request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

      try {
        final response = await request.send();

        if (response.statusCode == 200) {
          print('User registered successfully!');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User registered successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.push(context, MaterialPageRoute(builder: (context) => PoliticalPartyList()));
        } else {
          final responseBody = await http.Response.fromStream(response);
          final Map<String, dynamic> responseData = json.decode(responseBody.body);
          showError(responseData['message'] ?? 'Failed to register user.');
        }
      } catch (error) {
        showError('An error occurred: $error');
      }
    } else {
      showError('Please fill in all fields and select an image.');
      Navigator.push(context, MaterialPageRoute(builder: (context) => pp()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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