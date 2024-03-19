import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/sign_up_controller.dart';
import '../res/colors.dart';
import '../res/components/button.dart';
import '../res/components/check_account.dart';
import '../utils/routes/routes_name.dart';
import '../utils/utils.dart';

class LogInView extends StatefulWidget {
  const LogInView({super.key});

  @override
  State<LogInView> createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  SignUpController logInController = SignUpController();

  // FocusNode one = FocusNode();
  // FocusNode two = FocusNode();

  // final key = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.sliderOneColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppUtils.sizedBox(2, 0),
            const CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('asset/app-logo.png'),
            ),
            // Image.asset('asset/app-logo.png'),
            //email controller
            AppUtils.sizedBox(8, 0),
            TextFormField(
              // focusNode: one,
              controller: email,
              cursorColor: AppColors.defaultColor,
              keyboardType: TextInputType.emailAddress,
              decoration: AppUtils.decoration(
                  hintTe: "Enter Email", widget: AppUtils.sizedBox(0.0, 0.0)),
              textInputAction: TextInputAction.next,
              // onFieldSubmitted: (val) {
              //   AppUtils.fieldFocusChange(context, one, two);
              // },
            ),
            //password controller
            AppUtils.sizedBox(8, 0),
            Obx(() {
              return TextFormField(
                obscureText: logInController.isLogInSeen.value,
                obscuringCharacter: "*",
                // focusNode: two,
                controller: password,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                cursorColor: AppColors.defaultColor,
                onFieldSubmitted: (val) {
                  if (email.text.isEmpty) {
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
                    AppUtils.showFlushBar(
                        context, "Password cannot be less than six");
                  } else {
                    logInController.signInUser(
                        email: email.text.trim(),
                        password: password.text.trim(),
                        context: context);
                    email.clear();
                    password.clear();
                  }
                },
                decoration: AppUtils.decoration(
                    hintTe: "Enter Password",
                    widget: GestureDetector(
                      onTap: () {
                        logInController.isLoginShow();
                      },
                      child: Icon(
                        logInController.isLogInSeen.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 22,
                        color: AppColors.defaultColor,
                      ),
                    )),
              );
            }),
            //submit button
            AppUtils.sizedBox(18, 0),
            Obx(() {
              return ButtonCompo(
                  isLoading: logInController.isLogin.value,
                  onPress: () {
                    if (email.text.isEmpty) {
                      AppUtils.showFlushBar(context, "Please Enter Name");
                    } else if (email.text.isEmpty) {
                      AppUtils.showFlushBar(context, "Please Enter Email");
                    } else if (!email.text.contains("@")) {
                      AppUtils.showFlushBar(
                          context, "Please Enter Valid Email");
                    } else if (!email.text.contains(".")) {
                      AppUtils.showFlushBar(
                          context, "Please Enter Valid Email");
                    } else if (password.text.isEmpty) {
                      AppUtils.showFlushBar(context, "Please Enter Password");
                    } else if (password.text.length < 6) {
                      AppUtils.showFlushBar(
                          context, "Password cannot be less than six");
                    } else {
                      FocusScope.of(context).unfocus();
                      logInController.signInUser(
                          email: email.text.trim(),
                          password: password.text.trim(),
                          context: context);
                      email.clear();
                      password.clear();
                    }
                  },
                  buttonName: "Log In");
            }),
            AppUtils.sizedBox(6, 0),
            CheckAccountCompo(
                accountDesc: "Don't have an account?",
                onTap: () {
                  Navigator.pushNamed(context, RouteName.signUp);
                },
                buttonText: " Sign Up")
          ],
        ),
      ),
    );
  }
}
