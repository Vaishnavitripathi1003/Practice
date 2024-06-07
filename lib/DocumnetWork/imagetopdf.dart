import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file_plus/open_file_plus.dart';

class CameraToPdfPage extends StatefulWidget {
  @override
  _CameraToPdfPageState createState() => _CameraToPdfPageState();
}

class _CameraToPdfPageState extends State<CameraToPdfPage> {
  List<File> _images = [];
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();

    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin!.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          _openPdf(response.payload!);
        }
      },
    );
  }

  Future<void> _chooseSource() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.image,
                    allowMultiple: true, // Set allowMultiple to true
                  );

                  if (result != null) {
                    setState(() {
                      _images = result.paths.map((path) => File(path!)).toList();
                    });
                  }
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () async {
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _images = [File(pickedFile.path)];
                    });
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _convertToPdf(BuildContext context) {
    if (_images.isNotEmpty) {
      // Show the images in a horizontal sliding manner
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.8,
              child: PageView.builder(
                itemCount: _images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: Image.file(_images[index]),
                  );
                },
              ),
            ),
          );
        },
      ).then((_) {
        // Convert the images to PDF after the dialog is closed
        _convertImagesToPdf();
      });
    }
  }

  Future<void> _convertImagesToPdf() async {
    final pdf = pw.Document();

    for (var imageFile in _images) {
      final image = pw.MemoryImage(imageFile.readAsBytesSync());
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image),
            );
          },
        ),
      );
    }

    final output = await _savePdf(pdf);
    print('PDF saved to: ${output.path}');
    _showNotification(output.path);
  }

  Future<File> _savePdf(pw.Document pdf) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/document.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<void> _showNotification(String filePath) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your_channel_id', 'your_channel_name', channelDescription: 'your channel description',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin!.show(
      0,
      'PDF Conversion',
      'PDF saved to: $filePath',
      platformChannelSpecifics,
      payload: filePath,
    );
  }

  Future<void> _openPdf(String filePath) async {
    await OpenFile.open(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera to PDF'),
      ),
      body: Center(
        child: _images.isEmpty
            ? Text('No image selected')
            : ListView.builder(
          itemCount: _images.length,
          itemBuilder: (context, index) {
            return Image.file(_images[index]);
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _chooseSource,
            tooltip: 'Choose Image Source',
            child: Icon(Icons.add_a_photo),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () => _convertToPdf(context), // Pass the BuildContext
            tooltip: 'Convert to PDF',
            child: Icon(Icons.picture_as_pdf),
          ),
        ],
      ),
    );
  }
}


