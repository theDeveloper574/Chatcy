import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../controllers/sign_up_controller.dart';
import '../res/colors.dart';
import '../res/components/button.dart';
import '../res/components/check_account.dart';
import '../utils/routes/routes_name.dart';
import '../utils/utils.dart';
import '../widgets/circle_image_widget.dart';

String imagePostId = const Uuid().v4();

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  SignUpController pathCon = Get.put(SignUpController());

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    // one.dispose();
    // two.dispose();
    // three.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.sliderOneColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              return CircleImageWidget(
                onProfileChangeTap: () {},
                imageProvider: pathCon.imagePath.isEmpty
                    ? const AssetImage('asset/signup.png')
                    : FileImage(File(pathCon.imagePath.toString()))
                        as ImageProvider,
                onImageChangeTap: () {
                  Get.defaultDialog(
                      backgroundColor: AppColors.whiteColor,
                      buttonColor: AppColors.defaultColor,
                      title: 'Get Image From',
                      middleText: 'Camera OR Gallery',
                      textConfirm: 'Gallery',
                      confirmTextColor: Colors.white,
                      textCancel: 'Camera',
                      cancelTextColor: AppColors.defaultColor,
                      onCancel: () {
                        // print('pick image from gallery');
                        Navigator.pop(context);
                        pathCon.imagePath.value = '';
                        pathCon.pickImageCam();
                      },
                      onConfirm: () async {
                        Navigator.pop(context);
                        pathCon.imagePath.value = '';
                        pathCon.pickImageGall();
                      });
                },
              );
            }),
            // Image.asset('asset/signup.png'),
            AppUtils.sizedBox(40, 0),
            //name controller
            TextFormField(
              cursorColor: AppColors.defaultColor,
              controller: name,
              keyboardType: TextInputType.name,
              decoration: AppUtils.decoration(
                  hintTe: "Enter Name", widget: AppUtils.sizedBox(0.0, 0.0)),
              textInputAction: TextInputAction.next,
            ),
            //email controller
            AppUtils.sizedBox(8, 0),
            TextFormField(
              cursorColor: AppColors.defaultColor,
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: AppUtils.decoration(
                  hintTe: "Enter Email", widget: AppUtils.sizedBox(0.0, 0.0)),
              textInputAction: TextInputAction.next,
            ),
            //password controller
            AppUtils.sizedBox(8, 0),
            Obx(() {
              return TextFormField(
                obscureText: pathCon.isSignUPSeen.value,
                cursorColor: AppColors.defaultColor,
                controller: password,
                decoration: AppUtils.decoration(
                  hintTe: "Enter Password",
                  widget: GestureDetector(
                    onTap: () {
                      pathCon.isSignUpShow();
                    },
                    child: Icon(
                      pathCon.isSignUPSeen.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.defaultColor,
                      size: 22,
                    ),
                  ),
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (var string) async {
                  await submitform();
                },
              );
            }),
            //submit button
            AppUtils.sizedBox(18, 0),
            Obx(() {
              return ButtonCompo(
                isLoading: pathCon.isLoad.value,
                onPress: () async {
                  await submitform();
                },
                buttonName: "Sign Up",
              );
            }),
            AppUtils.sizedBox(6, 0),
            CheckAccountCompo(
              onTap: () {
                Navigator.pushNamed(context, RouteName.logIn);
              },
              accountDesc: "Already have an account?",
              buttonText: " Login",
            )
          ],
        ),
      ),
    );
  }

  Future<void> submitform() async {
    if (name.text.isEmpty) {
      AppUtils.showFlushBar(context, "Please Enter Name");
    } else if (email.text.isEmpty) {
      AppUtils.showFlushBar(context, "Please Enter Email");
    } else if (!email.text.contains("@")) {
      AppUtils.showFlushBar(context, "Please Enter Valid Email");
    } else if (!email.text.contains(".")) {
      AppUtils.showFlushBar(context, "Please Enter Valid Email");
    } else if (password.text.isEmpty) {
      AppUtils.showFlushBar(context, "Please Enter Password");
    } else if (password.text.length < 6) {
      AppUtils.showFlushBar(context, "Password Cannot Be Less Than Six Digit");
    } else if (pathCon.imagePath.isEmpty) {
      AppUtils.showFlushBar(context, "Please Enter Profile Image");
    } else {
      FocusScope.of(context).unfocus();
      final now = DateTime.now();
      var chatId = now.microsecondsSinceEpoch.toString().substring(12);
      await pathCon.setUser(
          email: email.text.trim(),
          password: password.text.trim(),
          context: context,
          name: name.text.trim(),
          chatId: chatId);
    }
  }
}
// String? validateEmail(String? value) {
//   const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
//       r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
//       r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
//       r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
//       r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
//       r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
//       r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
//   final regex = RegExp(pattern);
//
//   return value!.isNotEmpty && !regex.hasMatch(value)
//       ? 'Enter a valid email address'
//       : null;
// }
