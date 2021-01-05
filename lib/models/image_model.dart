import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class ImageModel extends ChangeNotifier {
  File _image;
  Future<List> _results;

  ImageModel() {
    loadModel();
  }

  File getImage() {
    return _image;
  }

  Future<List> getResults() {
    return _results;
  }

  void setImage(File image) {
    _image = image;
    _results = classifyImage(_image);
    notifyListeners();
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model.tflite', labels: 'assets/model_labels.txt');
  }

  Future<List> classifyImage(File image) async {
    return Tflite.runModelOnImage(
        path: _image.path,
        numResults: 2,
        threshold: 0.2,
        imageMean: 127.5,
        imageStd: 127.5
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
