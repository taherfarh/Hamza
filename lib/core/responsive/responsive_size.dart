
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class ResponsiveSize {
  final BuildContext context;
  final double size;
  ResponsiveSize({required this.context,required this.size });
  double getScaleFactor(BuildContext context) {
    double width=MediaQuery.sizeOf(context).width;
    if (width < 600) {
      return width/400;
    }else if(width <900){
      return width/700;
    }else{
      return width/1000;
    }
  }

  double Size(){
    double responsivesize=size*getScaleFactor(context);
    double lowerLimit =responsivesize * 0.8;
    double upperLimit =responsivesize * 1.2;
    return responsivesize.clamp(lowerLimit, upperLimit);
  }

  
}