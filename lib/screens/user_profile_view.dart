import 'package:chatcy/widgets/check_call_widget.dart';
import 'package:flutter/material.dart';

import '../res/colors.dart';
import '../utils/utils.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: AppColors.whiteColor,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: Center(
          child: Column(
            children: [
              AppUtilsChats.sizedBox(30, 0.0),
              const CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('asset/signup.png'),
                radius: 48,
              ),
              AppUtilsChats.sizedBox(30, 0.0),
              const Text(
                "Noman Yameen",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              AppUtilsChats.sizedBox(2, 0.0),
              const Text(
                "+92 304 5848585",
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              AppUtilsChats.sizedBox(20, 0.0),
              const Text(
                "Education",
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
