import 'dart:io';
import 'package:tflite_v2/tflite_v2.dart';

class SignLanguageModel {
  Future<void> loadModel() async {
    try {
      String? res = await Tflite.loadModel(
        model: 'assets/model.tflite',
        labels: 'assets/labels.txt',
      );
      print('Model loaded: $res');
    } catch (e) {
      print('Failed to load model: $e');

    }
  }

  Future<List<dynamic>?> detectSignLanguage(File image) async {
  try {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 1,
      threshold: 0.1,
      asynch: true
    );
    print('Model recognitions: $recognitions'); // Print output for inspection
    return recognitions;
  } catch (e) {
    print('Failed to run model on image: $e');
    return null;
  }
}


  void dispose() {
    Tflite.close();
  }
}
