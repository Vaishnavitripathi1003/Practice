import 'package:audio_service/audio_service.dart';
import 'package:camera/camera.dart';
import 'package:detectionapp/DocumnetWork/handwrittentext.dart';
import 'package:detectionapp/Scanners/barcodescanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';


import 'DocumnetWork/imagetopdf.dart';

import 'DocumnetWork/loadpdffromassets.dart';
import 'DocumnetWork/viewtopdf.dart';
import 'MapWork/Mapdemo.dart';
import 'Players/YoutubePlayerScreen.dart';
import 'Players/audiplayer.dart';
import 'Scanners/captchagenerator.dart';
import 'createcustomview/cusom view.dart';
import 'DocumnetWork/fetchtextfromimage.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // First Row
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: Container(
                        height: 160,
                        width: 160.0,
                        color: Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_search, size: 50, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              'Object Detection',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ObjectDetectionScreen()));
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        height: 160,
                        width: 160.0,
                        color: Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.audiotrack, size: 50, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              'Audio Player',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {

                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayerPage()));
                      },
                    ),
                  ],
                ),
              ),
              // Second Row
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: Container(
                        height: 160,
                        width: 160.0,
                        color: Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.picture_as_pdf, size: 50, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              'View to PDF',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PDFConverter()));
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        height: 160,
                        width: 160.0,
                        color: Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 50, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              'image to pdf',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CameraToPdfPage()));
                      },
                    ),
                  ],
                ),
              ),
              // Third Row
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: Container(
                        height: 160,
                        width: 160.0,
                        color: Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.video_library, size: 50, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              'Video Player',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => YoutubePlayerScreen()));
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        height: 160,
                        width: 160.0,
                        color: Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.map, size: 50, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              'Map',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapPage()));

                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: Container(
                        height: 160,
                        width: 160.0,
                        color: Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.vibration, size: 50, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              'Custom view',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CustomizedViewEditor()));
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        height: 160,
                        width: 160.0,
                        color: Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.multitrack_audio_rounded, size: 50, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              'Image Text Reader',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HandwrittenTextRecognitionPage()));
                      },
                    ),
                  ],
                ),
              ),

              /*===========================*/
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: Container(
                        height: 160,
                        width: 160.0,
                        color: Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.barcode, size: 50, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              'Barcode Scanner',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        WidgetsFlutterBinding.ensureInitialized();
                        final cameras = await availableCameras();
                        final firstCamera = cameras.first;
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => BarcodeScannerScreen(camera: firstCamera)));
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        height: 160,
                        width: 160.0,
                        color: Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.explicit_sharp, size: 50, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              'Excel',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {

                        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayerPage()));
                      },
                    ),
                  ],
                ),
              ),
              // Second Row
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: Container(
                        height: 160,
                        width: 160.0,
                        color: Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.closed_caption_off_sharp, size: 50, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              'Captcha Generator',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CaptchaScreen()));
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        height: 160,
                        width: 160.0,
                        color: Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit, size: 50, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              'load pdf from assets',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PdfViewerScreen()));
                      },
                    ),
                  ],
                ),
              ),
              // Third Row
            /*  Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: Container(
                        height: 160,
                        width: 160.0,
                        color: Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.video_library, size: 50, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              'Video Player',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => YoutubePlayerScreen()));
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        height: 160,
                        width: 160.0,
                        color: Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bluetooth, size: 50, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              'Map',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapPage()));

                      },
                    ),
                  ],
                ),
              ),*/

            ],
          ),
        ),
      ),
    );
  }
}
