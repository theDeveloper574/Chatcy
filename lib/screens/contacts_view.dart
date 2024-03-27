import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatcy/controllers/services/firebase_helper_method.dart';
import 'package:chatcy/main.dart';
import 'package:chatcy/model/call_history_model.dart';
import 'package:chatcy/utils/routes/routes_name.dart';
import 'package:chatcy/widgets/check_call_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/get_method_controllers.dart';
import '../controllers/provider/chat_view_provider.dart';
import '../model/chat_room_model.dart';
import '../model/contacts_model.dart';
import '../res/colors.dart';
import '../utils/utils.dart';
import '../widgets/call_info_detail_wid.dart';
import 'new_chat_view.dart';

class ContactView extends StatefulWidget {
  final bool isForward;
  const ContactView({super.key, this.isForward = false});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  List selectedUsers = [];
  GetMethodController getMethod = Get.put(GetMethodController());
  List id = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatViewProvider>(
      builder: (context, values, child) {
        return PickupLayout(
          scaffold: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: AppColors.defaultColor,
              iconTheme: IconThemeData(color: AppColors.whiteColor),
              elevation: 0.0,
              title: Text(
                widget.isForward ? "Forward to..." : "ChatCy Users",
                style: TextStyle(color: AppColors.whiteColor, fontSize: 18),
              ),
              actions: [
                widget.isForward
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22.0),
                        child: Icon(
                          Icons.search,
                          size: 26,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed(RouteName.userContactsView);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22.0),
                          child: Icon(
                            Icons.contact_emergency,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      )
              ],
            ),
            body: StreamBuilder(
              stream: getMethod.usersSnapshot(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'NO CHATCY USERS FOUND.',
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text("wait...."));
                } else if (snapshot.hasError) {
                  Text(snapshot.error.toString());
                } else {
                  List<UserModelContacts> list = snapshot.data!.docs
                      .map((e) => UserModelContacts.fromDocumentSnapshot(e))
                      .toList();
                  return ListView.builder(
                    itemCount: list.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, int index) {
                      var data = list[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 0.4),
                        decoration: BoxDecoration(
                          color:
                              (values.idsList.contains(data.userId.toString()))
                                  ? Colors.grey.withOpacity(0.3)
                                  : AppColors.whiteColor,
                        ),
                        child: CallInfoDetailAndProfileWidget(
                          onListTap: () async {
                            if (widget.isForward) {
                              if (id.contains(data.userId.toString())) {
                                id.remove(data.userId.toString());
                              } else {
                                id.add(data.userId.toString());
                              }

                              ///select user
                              values.selectName(
                                  data.name.toString(), data.userId.toString());
                            } else {
                              ///simple create chat room
                              ChatRoomModel? chatRoomMod =
                                  await getChatRoomModel(data.userId!);
                              if (chatRoomMod != null) {
                                if (mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => NewChatView(
                                        userID: data.userId!,
                                        userName: data.name!,
                                        profileUrl: data.imageUrl!,
                                        chatRoom: chatRoomMod,
                                        showStatus: data.status.toString(),
                                      ),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          videoCallWid: AppUtilsChats.sizedBox(0.0, 0.0),
                          audioCallWid: AppUtilsChats.sizedBox(0.0, 0.0),
                          imageProvider: Padding(
                            padding: const EdgeInsets.only(left: 14.0),
                            child: CircleAvatar(
                              radius: 22,
                              backgroundImage:
                                  CachedNetworkImageProvider(data.imageUrl!),
                              // backgroundImage: NetworkImage(data.imageUrl!),
                            ),
                          ),
                          about: data.about!,
                          nameTitle: data.name!,
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
            bottomSheet: values.idsList.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    decoration: BoxDecoration(
                        color: AppColors.defaultColor.withOpacity(0.7)),
                    height: 48,
                    child: ListView.builder(
                      itemCount: values.namesList.length,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, int index) {
                        return Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Text(
                              "${values.namesList[index]},",
                              style: TextStyle(
                                  fontSize: 18, color: AppColors.whiteColor),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : null,
            floatingActionButton: values.idsList.isNotEmpty
                ? FloatingActionButton(
                    shape: const CircleBorder(),
                    heroTag: "btn",
                    backgroundColor: AppColors.defaultColor,
                    onPressed: () async {
                      for (var ids in id) {
                        ChatRoomModel? chatRoomMod =
                            await getChatRoomModel(ids);

                        if (chatRoomMod != null) {
                          for (String msg in values.onTapList) {
                            if (msg.contains("chatVoices")) {
                              FirebaseHelper.sendMessageFor(
                                  msg: "",
                                  voice: msg,
                                  image: "",
                                  chatRoom: chatRoomMod);
                            } else if (msg.contains("chatImages")) {
                              FirebaseHelper.sendMessageFor(
                                  msg: "",
                                  voice: "",
                                  image: msg,
                                  chatRoom: chatRoomMod);
                            } else {
                              FirebaseHelper.sendMessageFor(
                                  msg: msg,
                                  voice: "",
                                  image: "",
                                  chatRoom: chatRoomMod);
                            }
                          }
                        }
                      }
                      values.checkLi();
                      flutterToast(message: "Message Forward.");
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.asset(
                        "asset/forward-mesage.png",
                        scale: 16.0,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(var length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );

  ///creating chat model
  Future<ChatRoomModel?> getChatRoomModel(String id) async {
    ChatRoomModel? chatRoom;
    CallHistoryModel? callHistoryModel;
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var chatRoomId = getRandomString(10);
    var callHisId = getRandomString(8);
    var storyId = getRandomString(4);
    // QuerySnapshot storySnapshot= await FirebaseFirestore.instance.collection("story").where("uid",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatRooms")
        .where("participants.$uid", isEqualTo: true)
        .where("participants.$id", isEqualTo: true)
        .get();
    QuerySnapshot snpCallHistory = await FirebaseFirestore.instance
        .collection("callHistory")
        .where("participants.$uid", isEqualTo: true)
        .where("participants.$id", isEqualTo: true)
        .get();
    if (snapshot.docs.length > 0 || snpCallHistory.docs.length > 0)
    // storySnapshot.docs.length > 0
    {
      var docData = snapshot.docs[0].data();
      var historyDocData = snpCallHistory.docs[0].data();
      // var storyDocData = storySnapshot.docs[0].data();

      ///model for chat room
      ChatRoomModel chatRoomModel =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      ///model for call history
      CallHistoryModel callHisModel =
          CallHistoryModel.fromMap(historyDocData as Map<String, dynamic>);

      ///model for story
      // StoryModel storyModel =
      //     StoryModel.fromMap(storyDocData as Map<String, dynamic>);
      chatRoom = chatRoomModel;
      callHistoryModel = callHisModel;
      // storyModelUser = storyModel;
    } else {
      ChatRoomModel chatRoomModel = ChatRoomModel(
          chatRoomId: chatRoomId,
          participants: {
            uid.toString(): true,
            id.toString(): true,
          },
          lastMessage: "",
          chatTime: DateTime.now(),
          users: [uid.toString(), id.toString()],
          toId: uid,
          fromId: id,
          toMessagesCount: 0,
          fromMessagesCount: 0);

      ///add call model
      CallHistoryModel callHistoryMod = CallHistoryModel(
          callHistoryId: callHisId,
          participants: {
            uid.toString(): true,
            id.toString(): true,
          },
          // lastMessage: "",
          callTime: DateTime.now(),
          users: [uid.toString(), id.toString()]);
      // StoryModel storyModelChk = StoryModel(
      //     storyId: storyId,
      //     participants: {
      //       uid.toString(): true,
      //       id.toString(): true,
      //     },
      //     createTime: DateTime.now(),
      //     users: [uid.toString(), id.toString()]);

      ///add story model

      await FirebaseFirestore.instance
          .collection("chatRooms")
          .doc(chatRoomId)
          .set(chatRoomModel.toMap());

      ///create call history collection
      await FirebaseFirestore.instance
          .collection("callHistory")
          .doc(callHisId)
          .set(callHistoryMod.toMap());

      ///create collection for story uploads
      // await FirebaseFirestore.instance
      //     .collection("story")
      //     .doc(storyId)
      //     .set(storyModelChk.toMap());
      chatRoom = chatRoomModel;
      callHistoryModel = callHistoryMod;
      // storyModelUser = storyModelChk;
    }
    callHistoryModel;
    // storyModelUser;
    return chatRoom;
  }
}
