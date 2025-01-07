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
  Uint8List? capturedImage;

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

        setState(() {
          capturedImage = imageBytes;
        });

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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
            Positioned(
            top: size.height * 0.05,
            left: size.width * 0.05,
            child: Container(
              width: size.width * 0.9,
              height: size.height * 0.15,
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xffc5f2c6),
              boxShadow: [
                BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3),
                ),
              ],
              ),
            ),
            ),
          Positioned(
            top: size.height * 0.05,
            left: size.width * 0.1,
            child: Container(
              width: size.width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Create a Saving Goal",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    "Good Picture = Good Diagnosis",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    "Take pictures from close enough and focus on the damaged part or the pest.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.21,
            child: Container(
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_isCameraInitialized)
                    Container(
                      width: size.width,
                      height: size.height * 0.4,
                      child: CameraPreview(_controller!),
                    )
                  else
                    CircularProgressIndicator(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: size.height * 0.06,
            child: Container(
              width: size.width,
              child: Column(
                children: [
                  if (predictionResult.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.all(size.width * 0.04),
                      child: Container(
                      width: size.width * 1,
                      padding: EdgeInsets.all(size.width * 0.02),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFCC00),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          spreadRadius: 3,
                        ),
                        ],
                      ),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                if (capturedImage != null)
                                  Container(
                                    width: size.width * 0.30,
                                    height: size.height * 0.15,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: MemoryImage(capturedImage!),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                SizedBox(width: size.width * 0.02),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Prediction Result:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        predictionResult,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FourthPage(diseaseName: diseaseName),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.arrow_forward,
                                    color: Color(0xFF015218),
                                  size: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _initializeCamera();
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.05),
                      GestureDetector(
                        onTap: _captureAndPredict,
                        child: Container(
                          width: 70,
                          height: 72,
                          decoration: BoxDecoration(
                            color: Color(0xFFFF0000),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Color(0xFFD6D6D6),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                         
                        ),
                      ),
                      SizedBox(width: size.width * 0.05),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FourthPage(diseaseName: ''),
                            ),
                          );
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "Go to Chat",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
