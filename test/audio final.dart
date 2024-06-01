import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';




class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final _player = AudioPlayer();

  MyAudioHandler() {
    _player.playbackEventStream.listen((event) {
      final playing = _player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: _mapProcessingState(_player.processingState),
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
      ));
    });

    _player.currentIndexStream.listen((index) {
      if (index != null && queue.value.isNotEmpty) {
        mediaItem.add(queue.value[index]);
      }
    });
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    final mediaSource = AudioSource.uri(Uri.parse(mediaItem.id));
    final newQueue = queue.value..add(mediaItem);
    queue.add(newQueue);
    await _player.setAudioSource(ConcatenatingAudioSource(children: newQueue.map((item) => AudioSource.uri(Uri.parse(item.id))).toList()));
  }

  Stream<Duration> get positionStream => _player.positionStream;

  Future<Duration?> getMediaItemDuration(String url) async {
    try {
      final audioSource = AudioSource.uri(Uri.parse(url));
      await _player.setAudioSource(audioSource);
      final duration = await _player.load();
      return duration;
    } catch (e) {
      print("Error fetching duration: $e");
      return null;
    }
  }

  AudioProcessingState _mapProcessingState(ProcessingState processingState) {
    switch (processingState) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
      default:
        throw Exception("Invalid state");
    }
  }
}

class PlayerPage extends StatefulWidget {
  final AudioHandler audioHandler;

  PlayerPage({required this.audioHandler});

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> with TickerProviderStateMixin {
  List<MediaItem> _mediaItems = [];
  late List<Duration> _durations;

  List<String> bhajanTitles = [
    "Flutter Animation Tutorial",
    "Ultimate Rickroll Compilation",
    "Luis Fonsi ft. Daddy Yankee",
    "How to Make a Chocolate Cake",
    "Introduction to Machine Learning"
  ];

  List<String> bhajanThumbnails = [
    "https://img.youtube.com/vi/XGK84Poeynk/mqdefault.jpg",
    "https://img.youtube.com/vi/XGK84Poeynk/mqdefault.jpg",
    "https://img.youtube.com/vi/XGK84Poeynk/mqdefault.jpg",
    "https://img.youtube.com/vi/XGK84Poeynk/mqdefault.jpg",
    "https://img.youtube.com/vi/XGK84Poeynk/mqdefault.jpg"
  ];

  List<String> bhajanDescriptions = [
    "Learn how to create animations with the Animated Container widget in Flutter.",
    "Enjoy the ultimate compilation of Rickroll videos from around the web!",
    "Watch the official music video for Despacito, the record-breaking hit song by Luis Fonsi and Daddy Yankee.",
    "Learn step-by-step how to bake a delicious chocolate cake at home.",
    "Get introduced to the basics of machine learning and its applications in this beginner-friendly tutorial."
  ];

  List<String> bhajanAudioUrls = [
    "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
    "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
    "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3",
    "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3",
    "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3"
  ];

  AnimationController? _animationIconController1;
  Duration _duration = Duration();
  Duration _position = Duration();
  bool issongplaying = false;
  int _currentBhajanIndex = -1;

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    widget.audioHandler.seek(newDuration);
  }

  @override
  void initState() {
    super.initState();

    _mediaItems = [
      for (int i = 0; i < bhajanAudioUrls.length; i++)
        MediaItem(
          id: bhajanAudioUrls[i],
          album: bhajanTitles[i],
          title: bhajanTitles[i],
          artUri: Uri.parse(bhajanThumbnails[i]),
        )
    ];

    widget.audioHandler.addQueueItems(_mediaItems);

    _animationIconController1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
      reverseDuration: Duration(milliseconds: 750),
    );

    widget.audioHandler.playbackState.listen((state) {
      final playing = state.playing;
      setState(() {
        issongplaying = playing;
        if (playing) {
          _animationIconController1?.forward();
        } else {
          _animationIconController1?.reverse();
        }
      });
    });

    widget.audioHandler.mediaItem.listen((mediaItem) {
      final index = mediaItem != null ? bhajanAudioUrls.indexOf(mediaItem.id) : -1;
      setState(() {
        _currentBhajanIndex = index;
      });
    });

    (widget.audioHandler as MyAudioHandler).positionStream.listen((position) {
      setState(() {
        _position = position;
      });
    });

    _durations = List<Duration>.filled(bhajanAudioUrls.length, Duration());

    for (int i = 0; i < bhajanAudioUrls.length; i++) {
      _getDuration(i);
    }
  }

  Future<void> _getDuration(int index) async {
    final duration = await (widget.audioHandler as MyAudioHandler).getMediaItemDuration(bhajanAudioUrls[index]);
    setState(() {
      _durations[index] = duration ?? Duration();
    });
  }

  @override
  void dispose() {
    _animationIconController1?.dispose();
    super.dispose();
  }

  void _playBhajan(int index) async {
    if (_currentBhajanIndex == index && issongplaying) {
      widget.audioHandler.pause();
    } else {
      await widget.audioHandler.skipToQueueItem(index);
      await widget.audioHandler.play();
      setState(() {
        _currentBhajanIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Player'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100.withOpacity(0.55),
          image: DecorationImage(
            image: AssetImage("assets/images/color1.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: bhajanTitles.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.network(
                        bhajanThumbnails[index],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(bhajanTitles[index]),
                      subtitle: Text(bhajanDescriptions[index]),
                      trailing: IconButton(
                        icon: Icon(
                          _currentBhajanIndex == index && issongplaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        onPressed: () {
                          _playBhajan(index);
                        },
                      ),
                    );
                  },
                ),
              ),
              if (_currentBhajanIndex != -1) ...[
                ClipOval(
                  child: Image.network(
                    bhajanThumbnails[_currentBhajanIndex],
                    width: MediaQuery.of(context).size.width - 200,
                    height: MediaQuery.of(context).size.width - 200,
                    fit: BoxFit.fill,
                  ),
                ),
                Slider(
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey,
                  value: _position.inSeconds.toDouble(),
                  max: _durations[_currentBhajanIndex].inSeconds.toDouble(),
                  onChanged: (double value) {
                    seekToSecond(value.toInt());
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.skip_previous, size: 55, color: Colors.white),
                      onPressed: () {
                        widget.audioHandler.skipToPrevious();
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        if (issongplaying) {
                          widget.audioHandler.pause();
                        } else {
                          widget.audioHandler.play();
                        }
                        setState(() {
                          issongplaying = !issongplaying;
                        });
                      },
                      child: ClipOval(
                        child: Container(
                          color: Colors.pink[600],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AnimatedIcon(
                              icon: AnimatedIcons.play_pause,
                              size: 55,
                              progress: _animationIconController1!,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.skip_next, size: 55, color: Colors.white),
                      onPressed: () {
                        widget.audioHandler.skipToNext();
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
