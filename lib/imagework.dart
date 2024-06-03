/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocr_scan_text/ocr_scan_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text OCR Demo',
      home: TextOcrPage(),
    );
  }
}

class TextOcrPage extends StatefulWidget {
  @override
  _TextOcrPageState createState() => _TextOcrPageState();
}

class _TextOcrPageState extends State<TextOcrPage> {
  final picker = ImagePicker();
  String extractedText = '';
  FlutterTts flutterTts = FlutterTts();

  Future pickImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      processImage(File(pickedFile.path));
    }
  }

  Future pickImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      processImage(File(pickedFile.path));
    }
  }

  Future<void> processImage(File pickedImage) async {
    try {
      final text = await OcrScanText.extractText(pickedImage.path);
      setState(() {
        extractedText = text;
      });
      readText();
    } catch (e) {
      print('Error extracting text: $e');
    }
  }

  Future<void> readText() async {
    await flutterTts.speak(extractedText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text OCR Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: pickImageFromGallery,
              child: Text('Select Image from Gallery'),
            ),
            ElevatedButton(
              onPressed: pickImageFromCamera,
              child: Text('Capture Image from Camera'),
            ),
            SizedBox(height: 20),
            Text(
              'Extracted Text:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              extractedText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
*/
