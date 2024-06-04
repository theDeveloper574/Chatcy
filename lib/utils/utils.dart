import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatcy/controllers/provider/chat_view_provider.dart';
import 'package:chatcy/main.dart';
import 'package:chatcy/model/message_model.dart';
import 'package:chatcy/screens/contacts_view.dart';
import 'package:chatcy/utils/routes/routes_name.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../res/colors.dart';

class AppUtilsChats {
  static const imageHolder =
      "https://images.pexels.com/photos/17077796/pexels-photo-17077796/free-photo-of-palazzo-pesaro-papafava-in-venice.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load";

  //set sizebox
  static Widget sizedBox(double h, double w) {
    return SizedBox(
      height: h,
      width: w,
    );
  }

  //set text field decoration and bottom sheet set
  static Widget bottomText({required Function() onTap, required String text}) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
            color: AppColors.defaultColor,
            fontSize: 16,
            fontWeight: FontWeight.w700),
      ),
    );
  }

  static Future setBottomSheet({
    required String addText,
    required String initialVal,
    required BuildContext context,
    required int maxLength,
    required Function() onSave,
    required Function(String)? onChanged,
  }) {
    return Get.bottomSheet(
      SizedBox(
        height: 180,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 38.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppUtilsChats.sizedBox(20.0, 0.0),
              Text(
                addText,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              TextFormField(
                initialValue: initialVal,
                onChanged: onChanged,
                // controller: nameEdit,
                autofocus: true,
                maxLength: maxLength,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                cursorColor: AppColors.defaultColor,
                decoration: AppUtilsChats.bottomSheetDecoration(),
              ),
              AppUtilsChats.sizedBox(8.0, 0.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppUtilsChats.bottomText(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      text: 'cancel'),
                  AppUtilsChats.sizedBox(0.0, 20),
                  AppUtilsChats.bottomText(onTap: onSave, text: 'save'),
                ],
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  //
  static InputDecoration decoration(
      {required String hintTe, required Widget widget}) {
    return InputDecoration(
        hintText: hintTe,
        isDense: true,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: AppColors.defaultColor.withOpacity(0.6), width: 1.2),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: AppColors.defaultColor.withOpacity(0.6), width: 1.2),
            borderRadius: BorderRadius.circular(10)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: AppColors.defaultColor.withOpacity(0.6), width: 1.2),
            borderRadius: BorderRadius.circular(10)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: AppColors.defaultColor.withOpacity(0.6), width: 1.2),
            borderRadius: BorderRadius.circular(10)),
        suffix: widget);
  }

  ///text field decoration for send image container
  static InputDecoration sendImageDecoration() {
    return InputDecoration(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
      hintText: "Add a caption...",
      hintStyle: const TextStyle(color: Colors.white),
      isDense: true,
      filled: true,
      fillColor: AppColors.defaultColor,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.defaultColor.withOpacity(0.6), width: 1.2),
          borderRadius: BorderRadius.circular(22)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.defaultColor.withOpacity(0.6), width: 1.2),
          borderRadius: BorderRadius.circular(22)),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.defaultColor.withOpacity(0.6), width: 1.2),
          borderRadius: BorderRadius.circular(22)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.defaultColor.withOpacity(0.6), width: 1.2),
          borderRadius: BorderRadius.circular(22)),
      // suffix:
    );
  }

  static InputDecoration bottomSheetDecoration() {
    return InputDecoration(
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1.2, color: AppColors.defaultColor)),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1.2, color: AppColors.defaultColor)),
    );
  }

  //set focus of the app
  ///code for focus field
  // static fieldFocusChange(
  //     BuildContext context, FocusNode current, FocusNode next) {
  //   current.unfocus();
  //   FocusScope.of(context).requestFocus(next);
  // }

  //show flush bar
  ///show flush bar for flutter
  static showFlushBar(BuildContext context, String message) {
    Flushbar(
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.all(20),
      backgroundGradient: LinearGradient(
        colors: [
          AppColors.defaultColor,
          AppColors.defaultColor.withOpacity(0.7),
          AppColors.defaultColor.withOpacity(0.5),
        ],
        stops: const [0.4, 0.7, 1],
      ),
      boxShadows: const [
        BoxShadow(
          color: Colors.white,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      icon: const Icon(
        Icons.warning,
        color: Colors.red,
      ),
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.circular(14),
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      message: message,
      messageSize: 17,
    ).show(context);
  }

  //show shimmer widget
  static Widget showShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      enabled: true,
      highlightColor: Colors.grey.withOpacity(0.4),
      child: ListTile(
        onTap: () {
          // print('okay good');
          // navigatorPop(context: context);
        },
        leading: CircleAvatar(
          // backgroundColor: Colors.grey,
          radius: 22,
          child: Text(
            "",
            style: TextStyle(fontSize: 22, color: Colors.grey.withOpacity(0.4)),
          ),
          // backgroundImage: contact.,
        ),
        title: Text(
          "loading...",
          style: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.grey.withOpacity(0.4)),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
          child: Text(
            "loading...",
            style: TextStyle(fontSize: 16, color: Colors.grey.withOpacity(0.4)),
          ),
        ),
      ),
    );
  }

  //single chat app bar
  static AppBar appBar(
      {required context,
      required Function() profileTap,
      required Function() onCallTap,
      required Function() onVideoTap,
      required Widget onUpMenuBut,
      required String image,
      required String userName,
      required String showStatus}) {
    return AppBar(
      toolbarHeight: 56,
      elevation: 0.0,
      // Set this height
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.sliderOneColor,

      ///show data for users
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppUtilsChats.sizedBox(0.0, 4),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          AppUtilsChats.sizedBox(0.0, 8),
          CircleAvatar(
            radius: 20,
            // backgroundColor: HexColor(widget.chatColor).withOpacity(0.9),
            // backgroundColor: HexColor(widget.chatColor).withOpacity(0.9),
            child: Hero(
              tag: 'chat-list-profile',
              child: CircleAvatar(
                radius: 18,
                backgroundImage: CachedNetworkImageProvider(image),
                // backgroundImage: AssetImage('asset/signup.png'),
              ),
            ),
          ),
          AppUtilsChats.sizedBox(0.0, 10),
          Expanded(
            child: InkWell(
              onTap: profileTap,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///username
                  Text(
                    userName,
                    style: GoogleFonts.roboto(
                        textStyle:
                            const TextStyle(color: Colors.black, fontSize: 16)),
                  ),
                  AppUtilsChats.sizedBox(5.0, 0.0),
                  Text(showStatus,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        overflow: TextOverflow.clip,
                      )),
                ],
              ),
            ),
          )
        ],
      ),

      ///show data for calls
      actions: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
                onTap: onCallTap,
                child: const Icon(Icons.call_outlined, color: Colors.black)),
            AppUtilsChats.sizedBox(0.0, 12.0),
            InkWell(
                onTap: onVideoTap,
                child:
                    const Icon(Icons.videocam_outlined, color: Colors.black)),
            AppUtilsChats.sizedBox(0.0, 0.0),
            onUpMenuBut,
          ],
        )
      ],
    );
  }

  //text field for write message
  static InputDecoration decorationMessage(String hintTe) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      hintText: hintTe,
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.defaultColor.withOpacity(0.3), width: 1.2),
          borderRadius: BorderRadius.circular(20)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.defaultColor.withOpacity(0.3), width: 1.2),
          borderRadius: BorderRadius.circular(20)),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.defaultColor.withOpacity(0.3), width: 1.2),
          borderRadius: BorderRadius.circular(20)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.defaultColor.withOpacity(0.3), width: 1.2),
          borderRadius: BorderRadius.circular(20)),
    );
  }

  //launch number for text message
  static Future<bool> showNumberLaunch() async {
    return await launch(
        enableJavaScript: false,
        enableDomStorage: false,
        statusBarBrightness: Brightness.light,
        forceSafariVC: false,
        forceWebView: false,
        universalLinksOnly: false,
        "sms:+923054904522?body=Let's chat on WhatsApp! It's a fast, simple, and secure app we can use to message and Bob call each other for free. Get it at $launch{https://whatsapp.com/dl/code=kUengDWSCj}");
  }

  static Widget showMobileContactUtils(
      {required Function() onInvite,
      required Color profileColor,
      required String name,
      required String contactDisplayName,
      required String phoneNum}) {
    return ListTile(
      onTap: onInvite,
      leading: CircleAvatar(
        backgroundColor: profileColor,
        radius: 22,
        child: Text(
          name,
          style: const TextStyle(fontSize: 22, color: Colors.white),
        ),
        // backgroundImage: contact.,
      ),
      title: Text(
        contactDisplayName,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
        child: Text(
          phoneNum,
          style: const TextStyle(fontSize: 14),
        ),
      ),
      trailing: Text(
        "Invite",
        style: TextStyle(
            color: AppColors.defaultColor,
            // fontStyle: FontStyle.italic,
            fontSize: 12),
      ),
    );
  }

  //show chat box
  static Widget chatBox(
      {required BuildContext context,
      required Decoration decoration,
      required String message,
      required Color msgTextColor,
      required String messageTim,
      required Color msgTimColor,
      required Widget sentOrNot,
      required Widget forwardCheck}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      decoration: decoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          forwardCheck,
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: [
          //     Image.asset(
          //       "asset/forword_Icon.png",
          //       scale: 26.2,
          //       color: Colors.grey,
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.only(bottom: 2.0),
          //       child: Text(
          //         "Forwarded",
          //         style: TextStyle(
          //           fontStyle: FontStyle.italic,
          //           color: Colors.grey,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontFamily: "popins",
                      color: msgTextColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                // Padding(
                //   padding:
                //       const EdgeInsets.only(top: 8.0, right: 4.0, left: 4.0),
                //   child: Text(
                //     messageTim,
                //     style: TextStyle(color: msgTimColor, fontSize: 10),
                //   ),
                // ),
                // Padding(
                //   padding:
                //       const EdgeInsets.only(top: 2.0, right: 4.0, left: 2.0),
                //   child: sentOrNot,
                // ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 8.0, right: 4.0, left: 4.0),
          //   child: Text(
          //     messageTim,
          //     style: TextStyle(color: msgTimColor, fontSize: 10),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 2.0, right: 4.0, left: 2.0),
          //   child: sentOrNot,
          // ),
        ],
      ),
    );
  }

  //show voice box
  static Widget voiceBox({
    required BuildContext context,
    required Color boxColor,
    required MainAxisAlignment rowAlignment,
    required Function() onPlayTap,
    required IconData icon,
    required double max,
    required double val,
    required Function(double getFutval) onSliderCh,
    required String seekTime,
    required String voiceTime,
  }) {
    return Container(
      height: 74,
      width: MediaQuery.of(context).size.width / 1.5,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(15),
      ),
      // padding: EdgeInsets.symmetric(vertical: 10),
      // width: ,
      margin: const EdgeInsets.symmetric(vertical: 4),
      // color: Colors.black,
      child: Row(
        mainAxisAlignment: rowAlignment,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 12),
              child: IconButton(
                  iconSize: 35,
                  onPressed: onPlayTap,
                  icon: Icon(icon),
                  color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: SliderTheme(
                    data: const SliderThemeData(
                      trackHeight: 2.6,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                    ),
                    child: Slider(
                        value: val,
                        inactiveColor: Colors.grey.withOpacity(0.4),
                        min: 0.0,
                        max: max,
                        onChanged: onSliderCh),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        seekTime,
                        style: const TextStyle(
                            color: Color(0xffA8A196), fontSize: 12),
                      ),
                      // Text(
                      //   formatTime(duration),
                      //   style: const TextStyle(color: Colors.white),
                      // )
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 10.0, top: 0.0, bottom: 0.0),
                        child: Text(
                          voiceTime,
                          style: const TextStyle(
                              color: Color(0xffA8A196), fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //show fake image loader
  static Widget imageLoader(String imagePath) {
    return Container(
      height: 300,
      width: 210,
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.defaultColor, width: 4.8),
          // color: Colors.red,
          borderRadius: BorderRadius.circular(10),
          color: AppColors.defaultColor.withOpacity(0.3),
          image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.dstATop),
              image: FileImage(
                File(imagePath),
              ),
              fit: BoxFit.fitWidth)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 0.8,
            child: CircularProgressIndicator(
              color: AppColors.whiteColor,
            ),
          ),
          AppUtilsChats.sizedBox(4.0, 0.0),
          Text(
            "Uploading...",
            style: TextStyle(color: AppColors.whiteColor),
          )
        ],
      ),
    );
  }

  //show fake voice loader
  static Widget voiceLoader({required BuildContext context}) {
    return Container(
      height: 74,
      width: MediaQuery.of(context).size.width / 1.5,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(15),
      ),
      // padding: EdgeInsets.symmetric(vertical: 10),
      // width: ,
      margin: const EdgeInsets.symmetric(vertical: 4),
      // color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Transform.scale(
              scale: 0.8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: CircularProgressIndicator(
                  color: AppColors.defaultColor,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: SliderTheme(
                    data: const SliderThemeData(
                      trackHeight: 2.6,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                    ),
                    child: Slider(
                        inactiveColor: Colors.grey.withOpacity(0.4),
                        min: 0,
                        max: 0.0,
                        value: 0.0,
                        onChanged: (val) {}),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "",
                        style:
                            TextStyle(color: Color(0xffA8A196), fontSize: 12),
                      ),
                      // Text(
                      //   formatTime(duration),
                      //   style: const TextStyle(color: Colors.white),
                      // )
                      Padding(
                        padding:
                            EdgeInsets.only(right: 10.0, top: 0.0, bottom: 0.0),
                        child: Text(
                          "00:00",
                          style:
                              TextStyle(color: Color(0xffA8A196), fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //message end code
  static Future<void> messageEndScroll(ScrollController controller) {
    return controller.animateTo(
      controller.position.maxScrollExtent * 1.2,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeIn,
    );
  }

  ///format date and time
  static String callHistoryTime(DateTime timestamp) {
    try {
      DateTime now = DateTime.now();
      DateTime dateTime = timestamp;

      // Calculate the difference in days
      int differenceInDays = now.difference(dateTime).inDays;

      String formattedDateTime;
      if (differenceInDays == 0) {
        // Display time in AM/PM format
        // formattedDateTime = DateFormat.jm().format(dateTime);
        formattedDateTime = 'Today at ${DateFormat.jm().format(dateTime)}';
      } else if (differenceInDays == 1) {
        formattedDateTime = 'Yesterday at ${DateFormat.jm().format(dateTime)}';
        // formattedDateTime = 'Yesterday';
      } else if (differenceInDays < 7) {
        // Display "X days ago" format
        formattedDateTime =
            '$differenceInDays days ago at ${DateFormat.jm().format(dateTime)}';
        // formattedDateTime = '$differenceInDays days ago';
      } else {
        // Display the date in "dd/MM/yyyy" format for dates more than 7 days ago
        formattedDateTime = DateFormat('dd/MM/yyyy').format(dateTime);
      }

      return formattedDateTime;
    } catch (e) {
      if (kDebugMode) {
        print("Error formatting date and time: $e");
      }
      return 'Error formatting date and time';
    }
  }

  static String firebaseTimestampSingleMsg(DateTime timestamp) {
    try {
      DateTime now = DateTime.now();
      DateTime dateTime = timestamp;

      // Calculate the difference in days
      int differenceInDays = now.difference(dateTime).inDays;

      String formattedDateTime;
      if (differenceInDays == 0) {
        // Display time in AM/PM format
        // formattedDateTime = DateFormat.jm().format(dateTime);
        formattedDateTime = DateFormat.jm().format(dateTime);
      } else if (differenceInDays == 1) {
        // formattedDateTime = 'Yesterday at ${DateFormat.jm().format(dateTime)}';
        formattedDateTime = 'Yesterday';
      } else if (differenceInDays < 7) {
        // Display "X days ago" format
        // formattedDateTime =
        //     '$differenceInDays days ago at ${DateFormat.jm().format(dateTime)}';
        formattedDateTime = '$differenceInDays days ago';
      } else {
        // Display the date in "dd/MM/yyyy" format for dates more than 7 days ago
        // formattedDateTime = DateFormat('dd/MM/yyyy').format(dateTime);
        formattedDateTime = '$differenceInDays D';
      }
      return formattedDateTime;
    } catch (e) {
      if (kDebugMode) {
        print("Error formatting date and time: $e");
      }
      return 'Error formatting date and time';
    }
  }

  ///set time
  static String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final senonds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      senonds,
    ].join(':');
  }

  ///scroll to end
  void scrollToEnd(ScrollController controller) {
    controller.animateTo(
      controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  static Widget showForwodbutton(
      {required Function() onDel, required Function() onForward}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
            onTap: () {},
            child: const Icon(
              Icons.star,
              color: Colors.black,
              size: 22,
            )),
        AppUtilsChats.sizedBox(0.0, 24.0),
        InkWell(
            onTap: onDel,
            child: const Icon(
              Icons.delete,
              color: Colors.black,
              size: 24,
            )),
        AppUtilsChats.sizedBox(0.0, 14.0),
        InkWell(
            onTap: onForward,
            child: Image.asset(
              "asset/forword_Icon.png",
              scale: 18.2,
            )),
        AppUtilsChats.sizedBox(0.0, 20.0),
      ],
    );
  }

  ///show signle chat AppBar
  static AppBar showWidgetSta(
      {required String urlImage,
      required String name,
      required String status,
      required String roomId,
      required String userId,
      required Function(String, String f, List<String> n) audioCall,
      required Function(String, String f, List<String> n) videoCall}) {
    return AppBar(
      toolbarHeight: 70,
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.sliderOneColor,

      ///show data for users
      title: Consumer<ChatViewProvider>(
        builder: (context, valueLis, child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppUtilsChats.sizedBox(0.0, 4),
              GestureDetector(
                onTap: () {
                  if (valueLis.onTapList.isEmpty) {
                    Navigator.pop(context);
                  } else {
                    valueLis.onTapList = [];
                    valueLis.messagesIdLi = [];
                  }
                },
                // onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              AppUtilsChats.sizedBox(0.0, 8),
              valueLis.onTapList.isNotEmpty
                  ? const SizedBox()
                  : CircleAvatar(
                      radius: 22,
                      child: Hero(
                        tag: 'chat-list-profile',
                        child: CircleAvatar(
                          radius: 24,
                          backgroundImage: CachedNetworkImageProvider(urlImage),
                        ),
                      ),
                    ),
              AppUtilsChats.sizedBox(0.0, 10),
              valueLis.onTapList.isNotEmpty
                  ? Text(valueLis.onTapList.length.toString())
                  : Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed(RouteName.userProfileView);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///username
                            Text(
                              name,
                              style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                            ),
                            AppUtilsChats.sizedBox(5.0, 0.0),
                            Text(
                              status,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 10,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
            ],
          );
        },
      ),

      ///show data for calls
      actions: [
        Consumer<ChatViewProvider>(
          builder: (context, valueLi, child) {
            return valueLi.onTapList.isEmpty
                ? AppUtilsChats.showRowCall(
                    userID: userId,
                    userName: name,
                    onAudio: audioCall,
                    onVideo: videoCall)
                : AppUtilsChats.showForwodbutton(
                    onDel: () {
                      for (var i in valueLi.messagesIdLi) {
                        valueLi.deleteMessages(
                            docIdChatRoom: roomId, messageId: i.toString());
                      }
                      flutterToast(message: "messages deleted.");
                    },
                    onForward: () {
                      valueLi.idsList = [];
                      valueLi.namesList = [];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ContactView(
                            isForward: true,
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
      ],
    );
  }

  static Widget textBox(
      MessageModel messageMod, String uid, BuildContext context) {
    return AppUtilsChats.chatBox(
        forwardCheck: messageMod.isForward == true
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(
                      "asset/forword_Icon.png",
                      scale: 28.0,
                      color: Colors.grey,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 2.0),
                      child: Text(
                        "Forwarded",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
        context: context,
        decoration: (messageMod.sender == uid)
            ? BoxDecoration(
                border: Border.all(
                  color: AppColors.defaultColor.withOpacity(0.01),
                ),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 0.01,
                      blurRadius: 0.01,
                      blurStyle: BlurStyle.solid)
                ],
                color: Colors.white,
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                ),
              )
            : BoxDecoration(
                color: AppColors.defaultColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
        message: messageMod.text.toString(),
        messageTim:
            AppUtilsChats.firebaseTimestampSingleMsg(messageMod.creation!),
        msgTextColor:
            (messageMod.sender == uid) ? AppColors.defaultColor : Colors.white,
        msgTimColor:
            (messageMod.sender == uid) ? AppColors.defaultColor : Colors.white,
        sentOrNot: (messageMod.sender == uid)
            ? const Icon(
                Icons.done_all_sharp,
                color: Colors.blue,
                size: 12,
              )
            : AppUtilsChats.sizedBox(0.0, 0.0));
  }

  ///show internet dialog
  static Future internetDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xffFFFFFF),
        title: Image.asset(
          'asset/no-internet.gif',
          height: 80,
          width: 80,
        ),
        content: const Text(
          "PLEASE CHECK YOUR INTERNET CONNECTION.",
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "Back",
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  static Widget showRowCall({
    required String userID,
    required String userName,
    required Function(String, String f, List<String> n) onVideo,
    required Function(String, String f, List<String> n) onAudio,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ZegoSendCallInvitationButton(
            margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
            iconSize: const Size(40, 40),
            buttonSize: const Size(40, 40),
            timeoutSeconds: 40,
            isVideoCall: true,
            onPressed: onAudio,
            resourceID:
                "my_call_cloud", //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
            invitees: [
              ZegoUIKitUser(
                id: userID,
                name: userName,
              ),
            ]),
        const SizedBox(
          width: 10.0,
        ),
        ZegoSendCallInvitationButton(
            iconSize: const Size(40, 40),
            buttonSize: const Size(40, 40),
            margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
            timeoutSeconds: 40,
            isVideoCall: false,
            onPressed: onVideo,
            resourceID:
                "my_call_cloud", //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
            invitees: [
              ZegoUIKitUser(
                id: userID,
                name: userName,
              ),
            ]),
        const SizedBox(
          width: 10.0,
        ),
      ],
    );
  }
}
