import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';


import 'DocumnetWork/Editpdf.dart';
import 'DocumnetWork/pdfconverter.dart';
import 'MapWork/Mapdemo.dart';
import 'Players/YoutubePlayerScreen.dart';
import 'Players/audiplayer.dart';
import 'createcustomview/cusom view.dart';
import 'imagework.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                            'PDF',
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
                          Icon(Icons.edit, size: 50, color: Colors.white),
                          SizedBox(height: 10),
                          Text(
                            'Editable PDF',
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
            ),


            /*================*/
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
                          Icon(Icons.edit, size: 50, color: Colors.white),
                          SizedBox(height: 10),
                          Text(
                            'Text Reader',
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
                     // Navigator.of(context).push(MaterialPageRoute(builder: (context) => TextReaderPage()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
