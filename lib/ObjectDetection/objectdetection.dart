/*
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:flutter/services.dart' show rootBundle;

class EmotionDetection extends StatefulWidget {
  const EmotionDetection({super.key});

  @override
  State<EmotionDetection> createState() => _EmotionDetectionState();
}

class _EmotionDetectionState extends State<EmotionDetection> {
  List<CameraDescription> cameras = [];
  bool isWorking = false;
  String output = "";
  CameraController? cameraController;
  CameraImage? image;
  late Interpreter interpreter;
  List<String> labels = [];

  @override
  void initState() {
    super.initState();
    getCameras().then((_) {
      loadModel();
      loadLabels();
    });
  }

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset('assets/emotion_model.tflite');
      print('Model loaded successfully');
    } catch (e) {
      print('Failed to load model: $e');
    }
    setState(() {});
  }

  Future<void> loadLabels() async {
    try {
      final labelData = await rootBundle.loadString('assets/emotion_labels.txt');
      labels = labelData.split('\n').where((label) => label.isNotEmpty).toList();
      print('Labels loaded: $labels');
    } catch (e) {
      print('Failed to load labels: $e');
    }
    setState(() {});
  }

  Future<void> getCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    loadCamera();
  }

  void loadCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController!.startImageStream((imageFromStream) {
          if (!isWorking) {
            isWorking = true;
            image = imageFromStream;
            runModel();
          }
        });
      });
    });
  }
  void runModel() async {
    if (image != null) {
      // Convert the CameraImage to a Float32List with appropriate preprocessing
      var input = imageToFloat32List(image!, 224);

      try {
        // Allocate space for the output tensor
        var outputShape = interpreter.getOutputTensor(0).shape;
        var output = List.generate(outputShape.reduce((a, b) => a * b), (index) => 0.0);

        // Run inference with the input and output tensors
        interpreter.run(input, output);

        // Process the output and update the UI
        int maxIndex = findMaxIndex(output);

        setState(() {
          this.output = labels[maxIndex];
          isWorking = false; // Set isWorking to false after inference
        });
      } catch (e) {
        print('Error during inference: $e');
      }
    }
  }







  int findMaxIndex(List<double> list) {
    var maxIndex = 0;
    var maxValue = list[0];
    for (var i = 1; i < list.length; i++) {
      if (list[i] > maxValue) {
        maxIndex = i;
        maxValue = list[i];
      }
    }
    return maxIndex;
  }



  Float32List imageToFloat32List(CameraImage image, int inputSize) {
    var convertedBytes = Float32List(inputSize * inputSize * 3);
    var bufferIndex = 0;

    for (int i = 0; i < inputSize; i++) {
      for (int j = 0; j < inputSize; j++) {
        var pixel = image.planes[0].bytes[i * inputSize + j];
        convertedBytes[bufferIndex++] = (pixel & 0xFF) / 255.0;
      }
    }
    return convertedBytes;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              if (cameraController != null && cameraController!.value.isInitialized)
                AspectRatio(
                  aspectRatio: cameraController!.value.aspectRatio,
                  child: CameraPreview(cameraController!),
                ),
              Center(child: Text(output)),
            ],
          ),
        ),
      ),
    );
  }
}
*/
