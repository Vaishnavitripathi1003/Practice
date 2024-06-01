import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../Entity/MasterData.dart';


class YoutubePlayerScreen extends StatefulWidget {
  @override
  _YoutubePlayerScreenState createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  List<MasterData> videoList = [];
  List<String> video_ID=["g_sfv9IVCu4","dQw4w9WgXcQ","kJQP7kiw5Fk","pTD9sT7QfdI","XGK84Poeynk"];
  List<String> Thumbnail=["https://img.youtube.com/vi/g_sfv9IVCu4/mqdefault.jpg","https://img.youtube.com/vi/dQw4w9WgXcQ/mqdefault.jpg","https://img.youtube.com/vi/kJQP7kiw5Fk/mqdefault.jpg","https://img.youtube.com/vi/pTD9sT7QfdI/mqdefault.jpg","https://img.youtube.com/vi/XGK84Poeynk/mqdefault.jpg"];
  List<String> Title=["Flutter Animation Tutorial","Ultimate Rickroll Compilation"," Luis Fonsi ft. Daddy Yankee","How to Make a Chocolate Cake","Introduction to Machine Learning"];
  List<String> shortDescriptions = [
    "Learn how to create animations with the Animated Container widget in Flutter.",
    "Enjoy the ultimate compilation of Rickroll videos from around the web!",
    "Watch the official music video for Despacito, the record-breaking hit song by Luis Fonsi and Daddy Yankee.",
    "Learn step-by-step how to bake a delicious chocolate cake at home.",
    "Get introduced to the basics of machine learning and its applications in this beginner-friendly tutorial."
  ];
  late YoutubePlayerController _controller;
  String _currentVideoId = '';

  @override
  void initState() {
    super.initState();
    _currentVideoId = video_ID[0]; // Set initial video ID
    _controller = YoutubePlayerController(
      initialVideoId: _currentVideoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Column(
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            onReady: () {
              // Do something when player is ready.
            },
            onEnded: (metadata) {
              // Do something when video ends.
            },
          ),
          SizedBox(height: 20), // Adding some space between the player and the list
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All Videos',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: videoList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(videoList[index].TopSlider_Content),
                          leading: GestureDetector(
                            child: Image.network(videoList[index].imagespath),
                            onTap: () {
                              _controller.load(videoList[index].Video_ID);
                              _currentVideoId = videoList[index].Video_ID;
                              /*setState(() {
                                _currentVideoId = videoList[index].Video_ID;
                              });*/
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getdata() async {
    List<MasterData> tempList = [];
    for (var i = 0; i < video_ID.length; i++) {
      MasterData masterData = MasterData(
        i.toString(),
        Title[i],
        shortDescriptions[i],
        video_ID[i],
        Thumbnail[i],
      );
      tempList.add(masterData);
    }
    setState(() {
      videoList = tempList;
    });
  }
}
