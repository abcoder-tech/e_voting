import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class CameraCapturePage extends StatefulWidget {
  @override
  _CameraCapturePageState createState() => _CameraCapturePageState();
}

class _CameraCapturePageState extends State<CameraCapturePage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    requestCameraPermission();
  }

  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
    }

    if (status.isGranted) {
      initializeCamera();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera permission is required to use this feature.')),
      );
    }
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[1], ResolutionPreset.high);
    _initializeControllerFuture = _controller!.initialize();
    setState(() {});
  }

  Future<void> captureImagesAutomatically() async {
    if (_isCapturing) return;
    _isCapturing = true;

    try {
      await _initializeControllerFuture;

      for (int i = 0; i < 10; i++) {
        final image = await _controller!.takePicture();
        await uploadImage(image.path);
        await Future.delayed(Duration(seconds: 1)); // Delay between captures
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('10 images captured and uploaded!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing images: $e')),
      );
    } finally {
      _isCapturing = false;
    }
  }

  Future<void> uploadImage(String imagePath) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.150.135.80:5000/capture'),
    );

    // Add fields to the request
    request.fields['face_id'] = idController.text;
    request.fields['name'] = nameController.text;

    // Add the image file
    request.files.add(await http.MultipartFile.fromPath('faceImage', imagePath));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded successfully!');
    } else {
      print('Failed to upload image: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Capture Selfie')),
      body: Column(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: CameraPreview(_controller!),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          TextField(
            controller: idController,
            decoration: InputDecoration(labelText: 'User ID'),
          ),
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          ElevatedButton(
            onPressed: captureImagesAutomatically,
            child: Text('Capture Selfie'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}