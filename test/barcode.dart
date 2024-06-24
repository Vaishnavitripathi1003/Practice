import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

class BarcodeScannerScreen extends StatefulWidget {
  final CameraDescription camera;

  const BarcodeScannerScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  late CameraController _controller;
  late BarcodeScanner _barcodeScanner;
  String _barcodeResult = 'Press the button to scan a barcode';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeCamera();
    _barcodeScanner = GoogleMlKit.vision.barcodeScanner();
  }

  Future<void> _initializeCamera() async {
    try {
      await _controller.initialize();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner'),
      ),
      body: Stack(
        children: <Widget>[
          CameraPreview(_controller),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _isProcessing ? null : _scanBarcode,
                  child: _isProcessing ? CircularProgressIndicator() : Text('Scan Barcode'),
                ),
                ElevatedButton(
                  onPressed: _isProcessing ? null : _pickImageFromGallery,
                  child: _isProcessing ? CircularProgressIndicator() : Text('Pick Image from Gallery'),
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                _barcodeResult,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _scanBarcode() async {
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
    });

    try {
      final image = await _controller.takePicture();
      _processImage(image.path);
    } catch (e) {
      setState(() {
        _barcodeResult = 'Error: $e';
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _processImage(pickedFile.path);
    }
  }

  void _processImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final List<Barcode> barcodes = await _barcodeScanner.processImage(inputImage);

      if (barcodes.isNotEmpty) {
        setState(() {
          _barcodeResult = barcodes.first.displayValue ?? barcodes.first.rawValue ?? 'No display value';
        });
      } else {
        setState(() {
          _barcodeResult = 'No barcode detected';
        });
      }
    } catch (e) {
      setState(() {
        _barcodeResult = 'Error: $e';
      });
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barcode Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BarcodeScannerScreen(camera: cameras.first),
    );
  }
}
