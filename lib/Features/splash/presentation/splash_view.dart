import 'package:flutter/material.dart';
import 'package:hamza/Features/home/cubit/get_user_cubit.dart';
import 'package:hamza/Features/home/presentation/views/Home_views.dart';
import 'package:hamza/Features/login/presentation/views/login_view.dart';
import 'package:hamza/Features/splash/database.dart';
import 'package:no_screenshot/no_screenshot.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final noscreenshot = NoScreenshot.instance;

  @override
  void initState() {
    super.initState();
    localdata();
    noscreenshot.screenshotOff();
    Future.delayed(Duration(seconds: 3)).then(
      (value) async {
        await localdata().creatdatapase();
        try {
          List<Map<String, dynamic>> m = await localdata().getdatabase();
          print(m[0]["auth"]);
          if (m[0]["auth"] == "true") {
            GetCoursesCubit().getuser(m[0]["phone"]);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => HomeViews(phone: m[0]["phone"])),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginView()),
            );
          }
        } catch (e) {
          print(e);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginView()),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    localdata().creatdatapase;

    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/Screenshot_2025-05-30_114645-removebg-preview.png'),
      ),
    );
  }
}
