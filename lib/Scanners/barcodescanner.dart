import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:camera/camera.dart';



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

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    _barcodeScanner = GoogleMlKit.vision.barcodeScanner();
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
      return Container();
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
            child: Center(
              child: ElevatedButton(
                onPressed: _scanBarcode,
                child: Text('Scan Barcode'),
              ),
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
    try {
      final image = await _controller.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final List<Barcode> barcodes = await _barcodeScanner.processImage(inputImage);

      if (barcodes.isNotEmpty) {
        setState(() {
          _barcodeResult = barcodes.first.value!.toString();
        });
      } else {
        setState(() {
          _barcodeResult = 'No barcode detected';
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
