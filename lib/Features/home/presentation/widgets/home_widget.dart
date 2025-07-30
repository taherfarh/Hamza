import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hamza/Features/home/cubit/get_user_cubit.dart';
import 'package:hamza/Features/home/cubit/get_user_states.dart';
import 'package:hamza/Features/home/data/get_user_model.dart';
import 'package:hamza/Features/video%20List/presentation/views/video_list_views.dart';
import 'package:hamza/core/responsive/responsive_size.dart';
import 'package:hamza/core/widgets/loading_page.dart';
import 'package:hamza/core/widgets/navigator.dart';

class HomeWidget extends StatefulWidget {
  final String phone;

  const HomeWidget({super.key, required this.phone});

  @override
  State<HomeWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<HomeWidget> {
  final List<String> items = [
    'Pediatrics',
    'NeuroMedicine',
    'NeuroSurgery',
    'GITMedicine',
    'Urology',
    'Orthopedics',
    'Ophthalmology',
    'Gynecology',
  ];

  List<GetUserModel> builld = [];
  List<String> m = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var course = BlocProvider.of<GetCoursesCubit>(context);
    await course.getuser(widget.phone);
    builld = course.get;

    if (builld.isNotEmpty) {
      m = [
        builld[0].a,
        builld[0].b,
        builld[0].c,
        builld[0].d,
        builld[0].e,
        builld[0].f,
        builld[0].g,
        builld[0].h,
        builld[0].i,
        builld[0].j,
        builld[0].k,
        builld[0].l,
        builld[0].m,
        builld[0].n,
        builld[0].o,
        builld[0].p,
        builld[0].q,
        builld[0].r,
        builld[0].s,
        builld[0].t,
        builld[0].u,
        builld[0].v,
        builld[0].w,
        builld[0].x,
        builld[0].y,
        builld[0].z,
      ]
          .where((e) => e != null && e!.isNotEmpty && e != "false")
          .map((e) => e!)
          .toList();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;

    return BlocBuilder<GetCoursesCubit, GetCourseStates>(
      builder: (context, state) {
        if (state is GetCourseloading || m.isEmpty) {
          return LoadingPage();
        } else if (state is GetCourseSuccessful) {
          return ListView.builder(
            itemCount: m.length,
            itemBuilder: (context, index) => m[index] == "false"
                ? Gap(1)
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        navigateToSecondPage(
                          context,
                          VideoListViews(coursename: m[index]),
                        );
                      },
                      child: Card(
                        elevation: 8,
                        shadowColor: Colors.black54,
                        child: Container(
                          width: width * 0.6,
                          height: height * 0.15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade200),
                          child: Row(
                            children: [
                              Gap(20),
                              Text(
                                m[index],
                                style: TextStyle(
                                    fontSize: ResponsiveSize(
                                            context: context, size: 25)
                                        .size,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Spacer(),
                              Padding(
                                  padding: EdgeInsets.only(right: 15),
                                  child: Icon(Icons.school))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          );
        } else {
          return Center(
            child: Text("Error"),
          );
        }
      },
    );
  }
}
