import 'package:flutter/material.dart';
import 'package:hamza/Features/play%20video/presentation/widgets/play_video_widget.dart';
import 'package:hamza/core/constant.dart';
import 'package:hamza/core/responsive/responsive_size.dart';
import 'package:no_screenshot/no_screenshot.dart';

class PlayVideoView extends StatefulWidget{
   final String videoname;
  final String coursname;
  final String firebaseUrl;

  const PlayVideoView({Key? key, required this.coursname,required this.videoname, required this.firebaseUrl}) : super(key: key);

  @override
  State<PlayVideoView> createState() => _VideoViewsState();
}

class _VideoViewsState extends State<PlayVideoView> {
  final noscreenshot=NoScreenshot.instance;
@override
  void initState() {
    super.initState();
    noscreenshot.screenshotOff();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kprimecolor,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
                'video',
                style: TextStyle(
                    fontSize: ResponsiveSize(context: context, size: 30).size,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
      ),
      body: VideoPlayerPage(coursname: widget.coursname,videolink: widget.videoname, firebaseUrl: widget.firebaseUrl,),
    );
  }
}