import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextOcrPage extends StatefulWidget {
  @override
  _TextOcrPageState createState() => _TextOcrPageState();
}

class _TextOcrPageState extends State<TextOcrPage> {
  final picker = ImagePicker();
  String extractedText = '';
  FlutterTts flutterTts = FlutterTts();
  TextRecognizer? textDetector;
  LanguageIdentifier? languageIdentifier;

  @override
  void initState() {
    super.initState();
    textDetector = GoogleMlKit.vision.textRecognizer();
    languageIdentifier = GoogleMlKit.nlp.languageIdentifier();
  }

  @override
  void dispose() {
    textDetector?.close();
    languageIdentifier?.close();
    super.dispose();
  }

  Future<void> pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      processImage(File(pickedFile.path));
    }
  }

  Future<void> pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      processImage(File(pickedFile.path));
    }
  }

  Future<void> processImage(File pickedImage) async {
    try {
      final inputImage = InputImage.fromFile(pickedImage);
      final RecognizedText recognizedText = await textDetector!.processImage(inputImage);
      final text = recognizedText.text;

      // Detect language of the text
      final language = await detectLanguage(text);

      setState(() {
        extractedText = text;
      });

      // Read text based on language
      if (language == 'hi') {
        await flutterTts.setLanguage('hi-IN');
      } else {
        await flutterTts.setLanguage('en-US');
      }
      readText();
    } catch (e) {
      print('Error extracting text: $e');
    }
  }

  Future<String> detectLanguage(String text) async {
    try {
      final langId = await languageIdentifier!.identifyLanguage(text);
      return langId;
    } catch (e) {
      print('Error detecting language: $e');
      return ''; // Default to empty string
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
