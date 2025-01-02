import 'dart:typed_data';  
import 'package:flutter/material.dart';  
import 'package:camera/camera.dart';  
import 'package:http/http.dart' as http;  
import 'dart:convert';  
import 'package:xyz/pages/fourth.dart';  
  
class ThirdPage extends StatefulWidget {  
  @override  
  _ThirdPageState createState() => _ThirdPageState();  
}  
  
class _ThirdPageState extends State<ThirdPage> {  
  CameraController? _controller;  
  bool _isCameraInitialized = false;  
  String predictionResult = '';  
  String diseaseName = '';  
  
  @override  
  void initState() {  
    super.initState();  
    _initializeCamera();  
  }  
  
  Future<void> _initializeCamera() async {  
    try {  
      final cameras = await availableCameras();  
      _controller = CameraController(  
        cameras.first,  
        ResolutionPreset.medium,  
      );  
      await _controller!.initialize();  
  
      if (!mounted) return;  
  
      setState(() {  
        _isCameraInitialized = true;  
      });  
    } catch (e) {  
      print('Error initializing camera: $e');  
    }  
  }  
  
  Future<void> _captureAndPredict() async {  
    if (_controller!.value.isInitialized) {  
      try {  
        XFile file = await _controller!.takePicture();  
        Uint8List imageBytes = await file.readAsBytes();  
  
        String url =  
            "https://cropdiseases-prediction.cognitiveservices.azure.com/customvision/v3.0/Prediction/eebc62f0-5040-4487-b226-a589b80a2d7a/classify/iterations/Iteration3/image";  
        Map<String, String> headers = {  
          "Prediction-Key": "EzvI1RCrDbz8W5jc05igBDDnzSSH4tB8uJzKOkcSI8vfzycU4m4uJQQJ99ALACYeBjFXJ3w3AAAIACOGhJsU",  
          "Content-Type": "application/octet-stream",  
        };  
  
        final response = await http.post(  
          Uri.parse(url),  
          headers: headers,  
          body: imageBytes,  
        );  
  
        if (response.statusCode == 200) {  
          final result = json.decode(response.body);  
          final predictions = result['predictions'] as List;  
          predictions.sort((a, b) =>  
              b['probability'].compareTo(a['probability']));  
          diseaseName = predictions.first['tagName'];  
          setState(() {  
            predictionResult = diseaseName;  
          });  
        } else {  
          print("Error: ${response.statusCode}");  
        }  
      } catch (e) {  
        print('Error capturing or sending photo: $e');  
      }  
    }  
  }  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        title: Text('Quick Capture & Predict'),  
      ),  
      body: Column(  
        children: [  
          if (_isCameraInitialized)  
            Container(  
              height: 300,  
              child: CameraPreview(_controller!),  
            )  
          else  
            Center(child: CircularProgressIndicator()),  
          SizedBox(height: 20),  
          ElevatedButton(  
            onPressed: _captureAndPredict,  
            child: Text('Capture & Predict'),  
          ),  
          if (predictionResult.isNotEmpty)  
            Padding(  
              padding: const EdgeInsets.all(16.0),  
              child: Text(  
                'Prediction Result: $predictionResult',  
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),  
                textAlign: TextAlign.center,  
              ),  
            ),  
          SizedBox(height: 20),  
          if (predictionResult.isNotEmpty)  
            ElevatedButton(  
              onPressed: () {  
                Navigator.push(  
                  context,  
                  MaterialPageRoute(  
                    builder: (context) => FourthPage(diseaseName: diseaseName),  
                  ),  
                );  
              },  
              child: Text('Ask Detailed Info about Disease'),  
            ),  
          SizedBox(height: 20),  
          ElevatedButton(  
            onPressed: () {  
              Navigator.push(  
                context,  
                MaterialPageRoute(  
                  builder: (context) => FourthPage(diseaseName: ''), // Clear disease name for normal chat  
                ),  
              );  
            },  
            child: Text('Go to Chat'),  
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
