import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as path;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PDFConverterScroll extends StatefulWidget {
  @override
  _PDFConverterScrollState createState() => _PDFConverterScrollState();
}

class _PDFConverterScrollState extends State<PDFConverterScroll> {
  final GlobalKey _containerKey = GlobalKey();
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initializeNotification();
  }

  void _initializeNotification() {
    print("Initializing notifications...");
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        print("Notification clicked. Payload: ${response.payload}");
        if (response.payload != null) {
          try {
            print("Attempting to open file...");
            await OpenFile.open(response.payload!);
            print("File opened successfully.");
          } catch (e) {
            print("Error opening file: $e");
          }
        }
      },
    );
    _createNotificationChannel();
  }

  void _createNotificationChannel() async {
    print("Creating notification channel...");
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'pdf_channel', // id
      'PDF Notifications', // name
      description: 'This channel is used for PDF notifications.', // description
      importance: Importance.max,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    print("Notification channel created.");
  }

  Future<void> _showNotification(String filePath) async {
    print("Showing notification for file: $filePath");
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'pdf_channel', // id
      'PDF Notifications', // name
      channelDescription: 'This channel is used for PDF notifications.', // description
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      0,
      'PDF Generated',
      'Your PDF has been successfully generated at $filePath',
      platformChannelSpecifics,
      payload: filePath,
    );
    print("Notification displayed.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Convert View to PDF'),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: _generatePdf,
          ),
        ],
      ),
      body: RepaintBoundary(
        key: _containerKey,
        child: _buildView(),
      ),
    );
  }

  Widget _buildView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Hello, PDF!',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          FlutterLogo(size: 100),
        ],
      ),
    );
  }
  Future<void> _generatePdf() async {
    try {
      // Request storage permissions
      var status = await Permission.storage.request();
      if (status.isGranted) {
        print("Generating PDF...");
        RenderRepaintBoundary boundary =
        _containerKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
        var image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();

        final pdf = pw.Document();
        final imageProvider = pw.MemoryImage(pngBytes);

        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(imageProvider),
              );
            },
          ),
        );

        // Save to the Downloads directory
        final downloadsDirectory = await getExternalStorageDirectory();
        final filePath = "${downloadsDirectory!.path}/Download/example.pdf";
        final file = File(filePath);
        await file.writeAsBytes(await pdf.save());
        print("PDF saved at: $filePath");

        _showNotification(filePath);
      } else {
        print("Storage permission denied");
      }
    } catch (e) {
      print("Error generating PDF: $e");
    }
  }
}
