import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamza/Features/login/cubit/login_cubit.dart';
import 'package:hamza/Features/login/presentation/widgets/login_widget.dart';
import 'package:no_screenshot/no_screenshot.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final noscreenshot = NoScreenshot.instance;
  @override
  void initState() {
    super.initState();
    noscreenshot.screenshotOff();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        body: LoginWidget(),
      ),
    );
  }
}
