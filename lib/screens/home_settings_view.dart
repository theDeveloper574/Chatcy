import 'package:chatcy/controllers/provider/chat_view_provider.dart';
import 'package:chatcy/controllers/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/get_method_controllers.dart';
import '../controllers/services/firebase_helper_method.dart';
import '../res/colors.dart';
import '../utils/routes/routes_name.dart';
import '../utils/utils.dart';
import '../widgets/call_info_detail_wid.dart';

class HomeSettingsView extends StatelessWidget {
  HomeSettingsView({super.key});
  final GetMethodController getMethodController = GetMethodController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatViewProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.whiteColor),
        elevation: 0.0,
        title: Text(
          "Settings",
          style: TextStyle(color: AppColors.whiteColor, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          CallInfoDetailAndProfileWidget(
            onListTap: () {
              Navigator.pushNamed(context, RouteName.myProfileView);
            },
            videoCallWid: AppUtils.sizedBox(0.0, 0.0),
            audioCallWid: AppUtils.sizedBox(0.0, 0.0),
            imageProvider: Hero(
              tag: "my-profile",
              child: Image.asset('asset/signup.png'),
            ),
            about: 'Hello there how are you!!!',
            nameTitle: 'My profile',
          ),
          const Divider(),
          InkWell(
              onTap: () async {
                var uid = FirebaseAuth.instance.currentUser!.uid;
                await NotificationService.unSubscribeToTopic(
                  uid,
                );
                provider.setModelTonul();
                await FirebaseHelper.setStatus("offline", uid);
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RouteName.logIn, (route) => false);
                });
              },
              child: const Text("Sign Out"))
        ],
      ),
    );
  }
}
