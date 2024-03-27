import 'package:chatcy/res/colors.dart';
import 'package:chatcy/screens/single_chat_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/provider/chat_view_provider.dart';
import '../controllers/services/firebase_helper_method.dart';
import '../model/chat_room_model.dart';
import '../model/user_data_model.dart';
import '../utils/utils.dart';
import '../widgets/chat_list_wid.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 1,
        (context, index) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("chatRooms")
                .where('users',
                    arrayContains: FirebaseAuth.instance.currentUser!.uid)
                .orderBy("chatTime")
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                return const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'No CHAT MESSAGES FOUND.',
                    textAlign: TextAlign.center,
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot snapshotQu = snapshot.data as QuerySnapshot;
                  return ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: snapshotQu.docs.length,
                    itemBuilder: (context, index) {
                      var uid = FirebaseAuth.instance.currentUser!.uid;
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                          snapshotQu.docs[index].data()
                              as Map<String, dynamic>);
                      Map<String, dynamic> participants =
                          chatRoomModel.participants!;
                      List<String> participantKey = participants.keys.toList();
                      participantKey.remove(uid);
                      return FutureBuilder(
                        future:
                            FirebaseHelper.getUserModById(participantKey[0]),
                        builder: (context, userData) {
                          if (userData.connectionState ==
                              ConnectionState.done) {
                            if (userData.data != null) {
                              UserDataModel userDataModel =
                                  userData.data as UserDataModel;
                              return ChatListAndCallWidget(
                                  textColor: Colors.grey,
                                  textFontWei: FontWeight.normal,
                                  imageProfile:
                                      userDataModel.imageUrl.toString(),
                                  onTap: () {
                                    context.read<ChatViewProvider>().onTapList =
                                        [];
                                    context
                                        .read<ChatViewProvider>()
                                        .messagesIdLi = [];
                                    // if(chat)
                                    if (chatRoomModel.toId == uid) {
                                    } else {
                                      FirebaseHelper.updateRead(
                                          chatRoomModel.chatRoomId!);
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => SingleChatView(
                                          showStatus: userDataModel.chatStatus
                                              .toString(),
                                          userName:
                                              userDataModel.name.toString(),
                                          userID:
                                              userDataModel.userId.toString(),
                                          profileUrl:
                                              userDataModel.imageUrl.toString(),
                                          chatRoom: chatRoomModel,
                                          chatId:
                                              userDataModel.chatId.toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  userName: userDataModel.name.toString(),
                                  iconWidget: (chatRoomModel.lastMessage == "")
                                      ? const Text("")
                                      : const Icon(
                                          Icons.done_all,
                                          color: Colors.blue,
                                          size: 12.0,
                                        ),
                                  msgOrCallTime: (chatRoomModel.lastMessage ==
                                          "")
                                      ? "Say! Hi to your New Friend"
                                      : chatRoomModel.lastMessage.toString(),
                                  widget: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        (chatRoomModel.lastMessage == "")
                                            ? ""
                                            : AppUtilsChats
                                                .firebaseTimestampSingleMsg(
                                                chatRoomModel.chatTime!,
                                              ),
                                        style: GoogleFonts.asap(fontSize: 10),
                                      ),
                                      const SizedBox(
                                        height: 8.0,
                                      ),
                                      chatRoomModel.toId == uid
                                          ? const SizedBox()
                                          : chatRoomModel.fromMessagesCount == 0
                                              ? const SizedBox()
                                              : Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        AppColors.defaultColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 4.0,
                                                        vertical: 2.0),
                                                    child: Text(
                                                      chatRoomModel
                                                          .fromMessagesCount
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .whiteColor),
                                                    ),
                                                  ),
                                                )
                                    ],
                                  ));
                            }
                          } else {
                            return const SizedBox();
                          }
                          return const SizedBox();
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child:
                        Text("An error occurred! NO Internet Connection Found"),
                  );
                } else {
                  return const Center(child: Text("NO CHATS FOUND"));
                }
              }
              return const SizedBox();
            },
          );
        },
      ),
    );
  }
}
