import 'package:flutter/material.dart';

void navigateToSecondPage(BuildContext context,Widget secondpage) {
    Navigator.of(context).push(_createRoute(secondpage));
  }

  Route _createRoute(Widget secondpage) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => secondpage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Start from the right
        const end = Offset.zero; // End at the center
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
