import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamza/Features/DownloadedVideos/DownloadedVideos.dart';
import 'package:hamza/Features/home/cubit/get_user_cubit.dart';
import 'package:hamza/Features/home/presentation/widgets/home_widget.dart';
import 'package:hamza/core/constant.dart';
import 'package:hamza/core/responsive/responsive_size.dart';
import 'package:iconly/iconly.dart';
import 'package:no_screenshot/no_screenshot.dart';

class HomeViews extends StatefulWidget {
  final String phone;
  const HomeViews({super.key, required this.phone});

  @override
  State<HomeViews> createState() => _HomeViewsState();
}

class _HomeViewsState extends State<HomeViews> {
  final noscreenshot = NoScreenshot.instance;

  @override
  void initState() {
    GetCoursesCubit().getuser(widget.phone);
    super.initState();
    noscreenshot.screenshotOff();
  }

  @override
  Widget build(BuildContext context) {
    GetCoursesCubit().getuser(widget.phone);
    return BlocProvider(
      create: (context) => GetCoursesCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: kprimecolor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Courses',
            style: TextStyle(
              fontSize: ResponsiveSize(context: context, size: 30).size,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: HomeWidget(phone: widget.phone),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DownloadedVideosPage()),
            );
          },
          icon: Icon(IconlyLight.download),
          label: Text(" Videos"),
          backgroundColor: kprimecolor,
        ),
      ),
    );
  }
}
