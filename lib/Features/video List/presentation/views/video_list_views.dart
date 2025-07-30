import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamza/Features/video%20List/cubit/List_cubit.dart';
import 'package:hamza/Features/video%20List/data/chick%20list.dart';
import 'package:hamza/Features/video%20List/presentation/widgets/video_List_widget.dart';
import 'package:hamza/core/constant.dart';
import 'package:hamza/core/responsive/responsive_size.dart';
import 'package:no_screenshot/no_screenshot.dart';

class VideoListViews extends StatefulWidget {
  final String coursename;
  const VideoListViews({super.key,required this.coursename});

  @override
  State<VideoListViews> createState() => _VideoViewsState();
}

class _VideoViewsState extends State<VideoListViews> {
  final noscreenshot = NoScreenshot.instance;
  @override
  void initState() {
    super.initState();
    noscreenshot.screenshotOff();
    ListCubit().getuser(widget.coursename);
  }
void Createdata() async{
    await Datachick().creatdatapase(widget.coursename);
  }
  @override
  Widget build(BuildContext context) {
    Createdata();
    ListCubit().getuser(widget.coursename);
    return BlocProvider(
      create: (context) => ListCubit(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kprimecolor,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text(
            '${widget.coursename}',
            style: TextStyle(
                fontSize: ResponsiveSize(context: context, size: 30).size,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
        body: VideoListWidget(coursename: widget.coursename,),
      ),
    );
  }
}
