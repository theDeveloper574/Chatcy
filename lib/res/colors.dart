import 'package:flutter/material.dart';

class AppColors {
  static Color whiteColor = const Color(0xffFFFFFF);
  static Color blackColor = Colors.black;
  static Color transColor = Colors.transparent;
  static Color defaultColor = const Color(0xff07052A);
  static Color buttonColor = const Color(0xff4D65C0);
  static Color grayFind = const Color(0xff8C919D);
  static Color sliderOneColor = const Color(0xffFFF0E6);
  static Color sliderTwoColor = const Color(0xffCFF3D5);
  static Color sliderThreeColor = const Color(0xffE6E5F8);
  static Color orangeColor = const Color(0xffE95F36);
  static Color blueColor = const Color(0xff07052A);
  static Color greyColor = const Color(0xff8C919D);
  static Color lightGreen = const Color(0xffF1F9F1);
  static Color lightPink = const Color(0xffF1F1FC);
  static Color lightBlue = const Color(0xffEDFCFF);
  static Color lightRed = const Color(0xffFFF2F2);
  static Color darkGreen = const Color(0xff2CA66F);
  static const List<Color> gradientColors = [
    Color(0xff6633FF),
    Color(0xff04F60B),
  ];
  static List<Color> colorsList = [
    orangeColor,
    greyColor,
    lightGreen,
    lightPink,
    lightBlue,
    lightRed,
    darkGreen,
  ];
}

const String serverKey =
    "AAAAb7VsNbY:APA91bGhdYv7Y4s3iz2h_VaAZyJwaMymdSmLuhsx7etsyK8iqNGxsi1VthJ_4nfYCCuWrOdtLbYHdrYNmzZ4La5OAMnsTrrcJSuiB6LuW58efN_G0fcdE6CYYGVsHfMnYqWCx7IW9cVo";
var url = "https://fcm.googleapis.com/fcm/send";
const String apiKey = "AIzaSyDAA_WphX8zyo7DZSXf_4L_sHOzaRuhXGI";
const urlChatBot =
    "https://generativelanguage.googleapis.com/v1beta2/models/chat-bison-001:generateMessage?key=$apiKey";
