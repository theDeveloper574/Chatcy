import 'dart:async';
import 'dart:math';

import 'package:chatcy/model/call_make_model.dart';
import 'package:chatcy/model/chat_room_model.dart';
import 'package:chatcy/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../model/user_data_model.dart';
import '../provider/chat_view_provider.dart';
import 'notification_service.dart';

class FirebaseHelper {
  static var uidCu = FirebaseAuth.instance.currentUser!.uid;
  static Future<UserDataModel?> getUserModById(String uid) async {
    UserDataModel? userDataModel;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("usersProfile")
        .doc(uid)
        .get();
    if (snapshot.data() != null) {
      userDataModel =
          UserDataModel.fromMap(snapshot.data() as Map<String, dynamic>);
    }
    return userDataModel;
  }

  // static StoryModel? storyModel;
  // List<StoryModel> stories;
  // static Future<StoryModel> statusStream() async {
  //   try {
  //     Stream<QuerySnapshot> snapshotStory = FirebaseFirestore.instance
  //         .collection('story')
  //         .where('users', arrayContains: FirebaseAuth.instance.currentUser!.uid)
  //         .snapshots();
  //     snapshotStory.listen((querySnapshot) {
  //       stories = querySnapshot.docs
  //           .map((e) => StoryModel.fromMap(e.data() as Map<String, dynamic>))
  //           .toList();
  //     });
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e.toString());
  //     }
  //   }
  //   return storyModel!;
  // }

  static Future setStatus(String status, String uid) async {
    await FirebaseFirestore.instance
        .collection("usersProfile")
        .doc(uid)
        .update({"status": status});
  }

  static Future updateRead(String userID) async {
    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(userID)
        .update({"fromMessageCount": 0});
  }

  ///send random message id
  static const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static final Random _rnd = Random();
  static String getRandomString(var length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => chars.codeUnitAt(
            _rnd.nextInt(chars.length),
          ),
        ),
      );

  ///send message single message
  static Future<void> sendMessage(
      {required TextEditingController message,
      required ChatRoomModel chatRoom,
      required String userID,
      required String senderName,
      required int fromCount}) async {
    String msg = message.text.trim();
    var msgID = getRandomString(4);
    var uid = FirebaseAuth.instance.currentUser!.uid;
    message.clear();
    if (msg != "") {
      MessageModel messageModel = MessageModel(
          messageId: msgID,
          sender: uid,
          text: msg,
          seen: false,
          creation: DateTime.now(),
          image: "",
          voice: "",
          imageText: "",
          isForward: false,
          isFav: false);
      FirebaseFirestore.instance
          .collection("chatRooms")
          .doc(chatRoom.chatRoomId)
          .collection("messages")
          .doc(messageModel.messageId.toString())
          .set(messageModel.toMap());
      chatRoom.lastMessage = msg;
      chatRoom.chatTime = DateTime.now();
      chatRoom.toId = uidCu;
      chatRoom.fromId = userID;
      chatRoom.toMessagesCount = 0;
      chatRoom.fromMessagesCount = fromCount;
      await NotificationService.sendNotifi(
          title: msg, uid: userID, body: senderName);
      FirebaseFirestore.instance
          .collection("chatRooms")
          .doc(chatRoom.chatRoomId)
          .set(chatRoom.toMap());
    }
  }

  ///send voice single message
  static Future<void> sendVoice(
      {required String voicePath,
      required ChatRoomModel chatRoom,
      required String userID,
      required String senderName,
      required int fromCount}) async {
    var msgID = getRandomString(4);
    var uid = FirebaseAuth.instance.currentUser!.uid;
    MessageModel messageModel = MessageModel(
        messageId: msgID,
        sender: uid,
        text: "",
        seen: false,
        creation: DateTime.now(),
        image: "",
        voice: voicePath,
        imageText: "",
        isForward: false,
        isFav: false);

    await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoom.chatRoomId)
        .collection("messages")
        .doc(messageModel.messageId.toString())
        .set(messageModel.toMap());
    chatRoom.lastMessage = "voice";
    chatRoom.chatTime = DateTime.now();
    //try to count messages

    chatRoom.toId = uidCu;
    chatRoom.fromId = userID;
    chatRoom.toMessagesCount = 0;
    chatRoom.fromMessagesCount = fromCount;
    await NotificationService.sendNotifi(
        title: "Send You a voice..", uid: userID, body: senderName);
    // await NotificationService.sendNotifi(
    //     title: "Send You a voice..", uid: userID, body: senderName);
    await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoom.chatRoomId)
        .set(chatRoom.toMap());
  }

  ///send image single message
  ///send image
  static Future<void> sendImage(
      {required String imagePath,
      required String text,
      required ChatRoomModel chatRoom,
      required String userID,
      required String senderName,
      required int fromCount}) async {
    var msgID = getRandomString(4);
    var uid = FirebaseAuth.instance.currentUser!.uid;
    MessageModel messageModel = MessageModel(
        messageId: msgID,
        sender: uid,
        text: "",
        seen: false,
        creation: DateTime.now(),
        image: imagePath,
        voice: "",
        imageText: text,
        isForward: false,
        isFav: false);
    await NotificationService.sendNotifi(
        title: "Send You a image..", uid: userID, body: senderName);
    // NotificationService.sendNotifi(
    //     title: "Send You a image..", uid: userID, body: senderName);

    await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoom.chatRoomId)
        .collection("messages")
        .doc(messageModel.messageId.toString())
        .set(messageModel.toMap());
    chatRoom.lastMessage = "image";
    chatRoom.chatTime = DateTime.now();
    //try to count messages

    chatRoom.toId = uidCu;
    chatRoom.fromId = userID;
    chatRoom.toMessagesCount = 0;
    chatRoom.fromMessagesCount = fromCount;
    await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoom.chatRoomId)
        .set(chatRoom.toMap());
  }

  ///send message by forward
  static Future<void> sendMessageFor({
    required String msg,
    required String image,
    required String voice,
    required ChatRoomModel chatRoom,
  }) async {
    var msgID = getRandomString(4);
    var uid = FirebaseAuth.instance.currentUser!.uid;
    MessageModel messageModel = MessageModel(
        messageId: msgID,
        sender: uid,
        text: msg.isEmpty ? "" : msg,
        seen: false,
        creation: DateTime.now(),
        image: image.isEmpty ? "" : image,
        voice: voice.isEmpty ? "" : voice,
        imageText: "",
        isForward: true,
        isFav: false);
    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoom.chatRoomId)
        .collection("messages")
        .doc(messageModel.messageId.toString())
        .set(messageModel.toMap());
    chatRoom.lastMessage = msg;
    chatRoom.chatTime = DateTime.now();
    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoom.chatRoomId)
        .set(chatRoom.toMap());
  }

  ///call history method
  static Future<void> sendHistory(CallMakeModel callHis, String docId) async {
    await FirebaseFirestore.instance
        .collection("callHistory")
        .doc(docId)
        .collection("calls")
        .doc(callHis.callId)
        .set(callHis.toMap());
  }

  ///audio or video call with notification
  static Future<void> sendMessageNotify(
      {required String msg,
      required String image,
      required String voice,
      required ChatRoomModel chatRoom,
      required String userID,
      required String senderName}) async {
    var msgID = getRandomString(4);
    var uid = FirebaseAuth.instance.currentUser!.uid;
    MessageModel messageModel = MessageModel(
        messageId: msgID,
        sender: uid,
        text: msg.isEmpty ? "" : msg,
        seen: false,
        creation: DateTime.now(),
        image: image.isEmpty ? "" : image,
        voice: voice.isEmpty ? "" : voice,
        imageText: "",
        isForward: false,
        isFav: false);
    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoom.chatRoomId)
        .collection("messages")
        .doc(messageModel.messageId.toString())
        .set(messageModel.toMap());
    chatRoom.lastMessage = msg;
    chatRoom.chatTime = DateTime.now();
    await NotificationService.sendNotifi(
        title: msg, uid: userID, body: senderName);
    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoom.chatRoomId)
        .set(chatRoom.toMap());
  }

  static void onUserLogin(String userName) {
    /// 1.2.1. initialized ZegoUIKitPrebuiltCallInvitationService
    /// when app's user is logged in or re-logged in
    /// We recommend calling this method as soon as the user logs in to your app.
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: appId,
      appSign: signInId,
      userID: FirebaseAuth.instance.currentUser!.uid,
      userName: userName,
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }

  //on call end
  static void onUserLogout() {
    /// 1.2.2. de-initialization ZegoUIKitPrebuiltCallInvitationService
    /// when app's user is logged out
    ZegoUIKitPrebuiltCallInvitationService().uninit();
  }

  static void actionButton(
      {required bool isVideo,
      required String targetUid,
      required String targetName}) async {
    ZegoSendCallInvitationButton(
        isVideoCall: isVideo,
        resourceID:
            "zegouikit_call", //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
        invitees: [
          ZegoUIKitUser(
            id: targetUid,
            name: targetName,
          ),
        ]);
  }
}
