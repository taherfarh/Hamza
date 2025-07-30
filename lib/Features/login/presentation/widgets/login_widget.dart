import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hamza/Features/home/presentation/views/Home_views.dart';
import 'package:hamza/Features/login/cubit/login_cubit.dart';
import 'package:hamza/Features/login/cubit/login_states.dart';
import 'package:hamza/Features/login/presentation/views/login_view.dart';
import 'package:hamza/core/responsive/responsive_size.dart';
import 'package:hamza/core/widgets/Custom_TextFromField.dart';
import 'package:hamza/core/widgets/Custom_bottom.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  var emailcontrolar = TextEditingController();
  var passwordcontrolar = TextEditingController();
  var key = GlobalKey<FormState>();
  bool visiblePassword = true;

  @override
  void initState() {
    super.initState();
    visiblePassword = true;
  }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<LoginCubit>(context);
    // double height=MediaQuery.sizeOf(context).height;
    // double width=MediaQuery.sizeOf(context).width;
    return BlocBuilder<LoginCubit, LoginStates>(
      builder: (context, state) {
        if (state is LoginInitStates) {
          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: key,
                  child: Column(
                    children: [
                      Image.asset(
                          'assets/images/Screenshot_2025-05-30_114645-removebg-preview.png'),
                      Gap(40),
                      Text(
                        'Login',
                        style: TextStyle(
                            fontSize:
                                ResponsiveSize(context: context, size: 45).size,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        "Where medicine is presented with Love",
                        style: TextStyle(
                            fontSize:
                                ResponsiveSize(context: context, size: 16).size,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const Gap(20),
                      CustomTextFromfield(
                        controlar: emailcontrolar,
                        validator: 'phone email',
                        label: 'phone',
                        obscureText: false,
                        textInputType: TextInputType.emailAddress,
                        iconData: Icons.email_outlined,
                        function: () {},
                      ),
                      const Gap(20),
                      CustomTextFromfield(
                        controlar: passwordcontrolar,
                        validator: 'Enter password',
                        label: 'password',
                        obscureText: visiblePassword,
                        textInputType: TextInputType.visiblePassword,
                        iconData: Icons.remove_red_eye_outlined,
                        function: () {
                          if (visiblePassword == false) {
                            setState(() {
                              visiblePassword = true;
                            });
                          } else {
                            setState(() {
                              visiblePassword = false;
                            });
                          }
                        },
                      ),
                      const Gap(30),
                      Custom_Bottom(
                        function: () async {
                          if (key.currentState!.validate()) {
                            cubit.checkuser(
                                emailcontrolar.text, passwordcontrolar.text);
                          }
                        },
                        widget: Text(
                          'Login',
                          style: TextStyle(
                              fontSize:
                                  ResponsiveSize(context: context, size: 20)
                                      .size,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (state is LoginSuccessfull) {
          return HomeViews(
            phone: cubit.phonee,
          );
        } else if (state is LoginLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is scendLogin) {
          Future.delayed(Duration(seconds: 2)).then(
            (value) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: const Text("You login in another device")));
            },
          );
          return LoginView();
        } else {
          Future.delayed(Duration(seconds: 2)).then(
            (value) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: const Text("phone or password rong")));
            },
          );
          return LoginView();
        }
      },
    );
  }
}
