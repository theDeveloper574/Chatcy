import 'package:chatcy/controllers/provider/chat_view_provider.dart';
import 'package:chatcy/model/call_model.dart';
import 'package:chatcy/widgets/show_calling_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPageVideo extends StatelessWidget {
  const CallPageVideo(
      {super.key,
      required this.onCallCut,
      required this.callID,
      required this.userID,
      required this.userName});
  final String callID;
  final String userID;
  final String userName;
  final Function() onCallCut;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('call')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data?.data() != null) {
              Call checkCall = Call.fromJson(snapshot.data!.data());
              if (checkCall.isCallPick == true) {
                return ZegoUIKitPrebuiltCall(
                  appID: appId,
                  appSign: signInId,
                  userID: userID,
                  userName: userName,
                  callID: callID,
                  onDispose: onCallCut,
                  config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
                );
              } else {
                return CallingWidget(
                  call: checkCall,
                );
              }
            } else {
              if (snapshot.data?.data() == null || snapshot.data == null) {
                Future.delayed(const Duration(), () {
                  Navigator.pop(context);
                });
              }
            }
          }
          return const SizedBox();
        });
  }
}
