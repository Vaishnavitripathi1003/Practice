import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:excel/excel.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:pdf/widgets.dart' as pw;
class Excelgenerator extends StatefulWidget {
  @override
  _ExcelgeneratorState createState() => _ExcelgeneratorState();
}

class _ExcelgeneratorState extends State<Excelgenerator> {
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
      'File Generated',
      'Your file has been successfully generated at $filePath',
      platformChannelSpecifics,
      payload: filePath,
    );
    print("Notification displayed.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Convert View to PDF/Excel'),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () => _requestStoragePermission(context, _generatePdf),
          ),
          IconButton(
              icon: Icon(Icons.table_chart),
              onPressed: () =>  _generateExcel()
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
    return SingleChildScrollView(
      child: Column(
        children: List.generate(100, (index) => _buildRow(index)),
      ),
    );
  }

  Widget _buildRow(int rowIndex) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(10, (index) => _buildField(rowIndex, index)),
      ),
    );
  }

  Widget _buildField(int rowIndex, int fieldIndex) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(16.0),
      color: Colors.grey[300],
      child: Text('Row $rowIndex, Field $fieldIndex'),
    );
  }

  Future<void> _requestStoragePermission(BuildContext context, Function generateFile) async {
    if (await Permission.storage.request().isGranted) {
      generateFile();
    } else {
      // Show alert dialog if permission is denied
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Storage Permission Required'),
              content: Text('This app needs storage permission to save the generated file.'),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Allow'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    if (await Permission.storage.request().isGranted) {
                      generateFile();
                    } else {
                      // Handle the case when permission is denied
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Storage permission is required to save the file.')),
                        );
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> _generatePdf() async {
    try {
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
      Directory? downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = await getExternalStorageDirectory();
      } else {
        downloadsDirectory = await getApplicationDocumentsDirectory();
      }

      final downloadsPath = path.join(downloadsDirectory!.path, 'Download');
      final filePath = path.join(downloadsPath, 'example.pdf');

      // Create the downloads directory if it doesn't exist
      final downloadsDir = Directory(downloadsPath);
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      print("PDF saved at: $filePath");

      _showNotification(filePath);
    } catch (e) {
      print("Error generating PDF: $e");
    }
  }
  Future<void> _generateExcel() async {
    try {
      print("Generating Excel...");
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];

      for (int i = 0; i < 100; i++) {

        List<CellValue> row = [];
        for (int j = 0; j < 10; j++) {

          row.add(TextCellValue( 'Row $i, Field $j'));
        }
        sheetObject.appendRow(row);
      }

      Directory? downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = await getExternalStorageDirectory();
      } else {
        downloadsDirectory = await getApplicationDocumentsDirectory();
      }

      final downloadsPath = path.join(downloadsDirectory!.path, 'Download');
      final filePath = path.join(downloadsPath, 'example.xlsx');

      final downloadsDir = Directory(downloadsPath);
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      final file = File(filePath);
      await file.writeAsBytes(excel.encode()!);
      print("Excel saved at: $filePath");

      _showNotification(filePath);
    } catch (e) {
      print("Error generating Excel: $e");
    }
  }
}


void main() {
  runApp(MaterialApp(
    home: Excelgenerator(),
  ));
}
