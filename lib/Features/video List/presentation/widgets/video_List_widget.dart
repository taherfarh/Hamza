// ignore_for_file: await_only_futures

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hamza/Features/play%20video/presentation/views/play_video_view.dart';
import 'package:hamza/Features/video%20List/cubit/List_States.dart';
import 'package:hamza/Features/video%20List/cubit/List_cubit.dart';
import 'package:hamza/Features/video%20List/data/Video%20List%20model.dart';
import 'package:hamza/Features/video%20List/data/chick%20list.dart';
import 'package:hamza/core/constant.dart';
import 'package:hamza/core/responsive/responsive_size.dart';
import 'package:hamza/core/widgets/loading_page.dart';
import 'package:hamza/core/widgets/navigator.dart';

class VideoListWidget extends StatefulWidget {
  final String coursename;
  const VideoListWidget({super.key, required this.coursename});

  @override
  State<VideoListWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<VideoListWidget> {
  List<bool> selectedItems = [];

  void _onCheckboxChanged(int index, bool? value, String videoname) async {
    selectedItems[index + 1] = value ?? false;
  }

  bool set = true;
  List<VideoListModel> list = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ListCubit().getuser(widget.coursename);
  }

  bool stringToBool(String value) {
    if (value.toLowerCase() == 'true') {
      return true;
    } else if (value.toLowerCase() == 'false') {
      return false;
    } else {
      throw FormatException('Invalid boolean string: $value');
    }
  }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ListCubit>(context);

    print(widget.coursename);

    Future<void> mm() async {
      await cubit.getuser(widget.coursename);
      list = await cubit.get;

      await Datachick().inserttodatabase(
          lict: "false", name: widget.coursename, videoname: "m");
      List<Map<String, dynamic>> m = await Datachick().getdatabase(
        widget.coursename,
      );
      print(await m);

      print(await list.length);
      Future.delayed(Duration(milliseconds: 0)).then(
        (value) async {
          if (m.length == 1) {
            selectedItems.add(false);
            for (var i = 0; i < list.length; i++) {
              await Datachick().inserttodatabase(
                  lict: "false",
                  name: widget.coursename,
                  videoname: list[i].name);
              selectedItems.add(false);
            }
          } else {
            selectedItems.clear();
            for (var i = 0; i < list.length + 1; i++) {
              selectedItems.add(stringToBool(m[i]['lict']));
            }
          }
          if (set == true) {
            setState(() {
              set = false;
            });
          }
        },
      );

      print(selectedItems);
    }

    mm();

    print(selectedItems.length);
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return BlocBuilder<ListCubit, ListStates>(
      builder: (context, state) {
        if (state is InitListStates || state is LoadingListStates) {
          return LoadingPage();
        } else if (state is SuccessfulListStates) {
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  navigateToSecondPage(
                      context,
                      PlayVideoView(
                        coursname: widget.coursename,
                        videoname: list[index].name, firebaseUrl: list[index].downloadLink,
                      ));
                },
                child: Card(
                  elevation: 8,
                  shadowColor: Colors.black,
                  child: Container(
                      width: width * 0.6,
                      height: height * 0.1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade200),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Gap(10),
                            Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                  fontSize:
                                      ResponsiveSize(context: context, size: 15)
                                          .size,
                                  fontWeight: FontWeight.bold,
                                  color: kprimecolor),
                            ),
                            Gap(10),
                            SizedBox(
                              width: width * 0.6,
                              child: Text(
                                list[index].name,
                                softWrap: true, // This is true by default
                                maxLines: 3, // Optional: limit to 3 lines
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: ResponsiveSize(
                                            context: context, size: 15)
                                        .size,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            selectedItems.length == 0
                                ? Gap(1)
                                : Checkbox(
                                    value: selectedItems[index + 1],
                                    onChanged: (value) async {
                                      await Datachick().updatadata(
                                          widget.coursename,
                                          list[index].name,
                                          value.toString());
                                      setState(() {
                                        _onCheckboxChanged(
                                            index, value, list[index].name);
                                      });
                                    },
                                  )
                          ],
                        ),
                      )),
                ),
              ),
            ),
          );
        } else {
          return Text(" ");
        }
      },
    );
  }
}
