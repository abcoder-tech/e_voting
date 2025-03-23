import 'dart:convert';
import 'dart:io';
import 'package:e_voting/pages/NEBE/political_party_list.dart';
import 'package:e_voting/pages/loginpage.dart';

import 'package:e_voting/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class UpdatePoliticalParty extends StatefulWidget {
  final String email;
  final String name;
  final String? ima;
  const UpdatePoliticalParty({super.key, required this.email, required this.name, this.ima});


  @override
  _UpdatePoliticalPartyState createState() => _UpdatePoliticalPartyState();
}

class _UpdatePoliticalPartyState extends State<UpdatePoliticalParty> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  XFile? _image;

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name; // Set the initial value here
  }


  @override
  void dispose() {
    _nameController.dispose(); // Dispose the controller
    super.dispose();
  }




  Future<void> _updateParty() async {
    if (_formKey.currentState?.validate() ?? false) { // Validate the form
      try {
        String updatedName = _nameController.text; // Get the updated name from the controller
        bool success = await updatePoliticalParty(widget.email, updatedName, _image); // Pass the updated name and image
        if (success) {

          QuickAlert.show(
            context:context,
            type:QuickAlertType.success,
            text:"you succesfully update party information",
          );

          await Future.delayed(Duration(seconds: 1));

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PoliticalPartyList())); // Navigate back to the previous screen
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating party: $e')),
        );
      }
    }
  }







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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Political Party')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  onChanged: (value) => _name = value,
        
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
        

        
                SizedBox(height: 20),
        
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Pick Image'),
                ),
                _image != null ? Image.file(File(_image!.path)) : Container(

                  height: 180,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    image: DecorationImage(
                      image: widget.ima != null ? MemoryImage(base64Decode(widget.ima!)) : AssetImage('lib/images/default.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateParty,
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
