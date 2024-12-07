import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import '/utils/sign_language_detection.dart';

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({Key? key}) : super(key: key);

  @override
  _DetectionScreenState createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  late ScreenshotController _screenshotController;
  late SignLanguageModel _signLanguageModel;
  String _detectedSign = '';
  bool _isCameraInitialized = false;
  Timer? _detectionTimer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _screenshotController = ScreenshotController();
    _signLanguageModel = SignLanguageModel();
    _signLanguageModel.loadModel();
  }

  @override
  void dispose() {
    _controller.dispose();
    _detectionTimer?.cancel();
    _signLanguageModel.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _controller = CameraController(_cameras.first, ResolutionPreset.max);
        await _controller.initialize();
        setState(() {
          _isCameraInitialized = true;
        });
        _startDetection();
      } else {
        print('No cameras available');
      }
    } catch (e) {
      print('Error initializing camera: $e');
      _showErrorDialog('Error initializing camera: $e');
    }
  }

  void _startDetection() {
    _detectionTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      try {
        _screenshotController.capture().then((Uint8List? image) {
          if (image != null) {
            _detectSignLanguage(image);
          }
        }).catchError((onError) {
          print(onError);
          _showErrorDialog('Screenshot error: $onError');
        });
      } catch (e) {
        print('Error in detection: $e');
        _showErrorDialog('Error in detection: $e');
      }
    });
  }

  void _detectSignLanguage(Uint8List imageBytes) async {
  try {
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/frame.jpg';
    await File(path).writeAsBytes(imageBytes);

    print('Image saved at: $path');  // Log the image path

    final result = await _signLanguageModel.detectSignLanguage(File(path));
    if (result != null && result.isNotEmpty) {
      setState(() {
        _detectedSign = result[0]['label'];
      });
    } else {
      setState(() {
        _detectedSign = 'Tidak ada bahasa isyarat terdeteksi';
      });
    }
  } catch (e) {
    print('Error detecting sign language: $e');
    _showErrorDialog('Error detecting sign language: $e');
  }
}


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFe9f7f9), // Warna latar belakang halaman
      appBar: AppBar(
        title: const Text(
          'Terjemah Bahasa Isyarat',
          style: TextStyle(color: const Color(0xFF04364A)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF64CCC5), // Warna tema AppBar
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isCameraInitialized
          ? Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Screenshot(
                      controller: _screenshotController,
                      child: CameraPreview(_controller),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF64CCC5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      _detectedSign.isNotEmpty ? _detectedSign : "Hasil deteksi...",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}