import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

class HandwrittenTextRecognitionPage extends StatefulWidget {
  @override
  _HandwrittenTextRecognitionPageState createState() => _HandwrittenTextRecognitionPageState();
}

class _HandwrittenTextRecognitionPageState extends State<HandwrittenTextRecognitionPage> {
  final ImagePicker _picker = ImagePicker();
  String _recognizedText = '';
  bool _isProcessing = false;
  Map<String, dynamic>? _configurations;

  Future<void> _loadTessData() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String tessdataPath = '${appDir.path}/tessdata';
    final Directory tessdataDir = Directory(tessdataPath);

    if (!tessdataDir.existsSync()) {
      tessdataDir.createSync(recursive: true);
    }

    final File file = File('$tessdataPath/eng.traineddata');
    if (!file.existsSync()) {
      final ByteData data = await rootBundle.load('assets/tessdata/eng.traineddata');
      final List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await file.writeAsBytes(bytes);
    }
  }

  Future<void> _loadConfigurations(String configPath) async {
    try {
      final String configContent = await rootBundle.loadString(configPath);
      final Map<String, dynamic> configurations = json.decode(configContent);
      setState(() {
        _configurations = configurations;
      });
    } catch (e) {
      setState(() {
        _recognizedText = 'Error loading configurations: ${e.toString()}';
      });
    }
  }

  Future<void> _recognizeText(ImageSource source) async {
    await _loadTessData();
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final String text = await FlutterTesseractOcr.extractText(
        pickedFile.path,
        language: 'eng',
        args: _configurations,
      );
      setState(() {
        _recognizedText = text;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _recognizedText = 'Error: ${e.toString()}';
        _isProcessing = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Load your configurations here
    _loadConfigurations('assets/tessdata/tessdata_config.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Handwritten Text Recognition'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _isProcessing ? null : () => _recognizeText(ImageSource.camera),
              child: _isProcessing ? CircularProgressIndicator() : Text('Select Image from Camera'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isProcessing ? null : () => _recognizeText(ImageSource.gallery),
              child: _isProcessing ? CircularProgressIndicator() : Text('Select Image from Gallery'),
            ),
            SizedBox(height: 20),
            Text(_recognizedText),
          ],
        ),
      ),
    );
  }
}
