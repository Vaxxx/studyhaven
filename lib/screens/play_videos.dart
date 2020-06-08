import 'package:flutter/material.dart';
import 'package:studyhaven/screens/chewie_player.dart';
import 'package:video_player/video_player.dart';

class PlayVideos extends StatefulWidget {
  final String url;

  const PlayVideos({Key key, this.url}) : super(key: key);

  @override
  _PlayVideosState createState() => _PlayVideosState();
}

class _PlayVideosState extends State<PlayVideos> {
  String finalPath = "";
  @override
  void initState() {
    String firstPath = "https://fearlessnaija.com/projectapp/uploads/";
    String secondPath = widget.url.toString();
    print('Second path...................$secondPath');
    finalPath = "$firstPath$secondPath";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("finalPath....................................$finalPath");
    return Scaffold(
      appBar: AppBar(
        title: Text('Video player'),
      ),
      body: ListView(
        children: <Widget>[
          ChewiePlayer(
            videoPlayerController: VideoPlayerController.network(finalPath),
            //  "https://fearlessnaija.com/projectapp/uploads/EnglishLanguage-LearnEnglishPart1.mp4,"),
            looping: true,
          ),
        ],
      ),
    );
  }
}
