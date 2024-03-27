import 'dart:io';

import 'package:chatcy/controllers/provider/chat_view_provider.dart';
import 'package:chatcy/controllers/services/firebase_helper_method.dart';
import 'package:chatcy/widgets/audio_slider_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../controllers/messages_controllers.dart';
import '../controllers/sign_up_controller.dart';
import '../model/call_make_model.dart';
import '../model/chat_room_model.dart';
import '../model/message_model.dart';
import '../res/colors.dart';
import '../utils/utils.dart';
import '../widgets/image_with_text_widget.dart';
import '../widgets/show_emoji_keyboard.dart';
import '../widgets/show_profile_img_wid.dart';
import '../widgets/text_field_signle_chat_widget.dart';

class SingleChatView extends StatefulWidget {
  final String userName;
  final String userID;
  final String profileUrl;
  final ChatRoomModel? chatRoom;
  final String showStatus;
  final String chatId;
  const SingleChatView(
      {super.key,
      required this.userName,
      required this.userID,
      required this.profileUrl,
      required this.chatRoom,
      required this.showStatus,
      required this.chatId});

  @override
  State<SingleChatView> createState() => _SingleChatViewState();
}

class _SingleChatViewState extends State<SingleChatView> {
  TextEditingController message = TextEditingController();
  TextEditingController messageImageCon = TextEditingController();
  MessageControllers imageCon = Get.put(MessageControllers());
  SignUpController imgPth = Get.put(SignUpController());
  ScrollController controller = ScrollController();
  bool isPlaying = false;
  bool isOpen = false;
  @override
  void initState() {
    final provider = Provider.of<ChatViewProvider>(context, listen: false);
    FirebaseHelper.onUserLogin(provider.userInfo!.name.toString());
    provider.getDocIdChR(widget.chatRoom!.chatRoomId!);
    provider.callHisoryId();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('build called');
    ChatViewProvider chatProvider =
        Provider.of<ChatViewProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.lightGreen,
      appBar: AppUtilsChats.showWidgetSta(
        userId: widget.userID,
        // audioCall: () async {
        //   bool isNetOn = await chatProvider.hasNetwork();
        //   if (isNetOn) {
        //     String id = FirebaseHelper.getRandomString(4);
        //     CallUtils.dialAudio(
        //         isCallPick: false,
        //         callId: id,
        //         callType: "audio",
        //         // context: context,
        //         from: {
        //           "uid": chatProvider.userInfo!.userId,
        //           "name": chatProvider.userInfo!.name,
        //           "picURL": chatProvider.userInfo!.imageUrl,
        //         },
        //         to: {
        //           "uid": widget.userID,
        //           "name": widget.userName.toString(),
        //           "picURL": widget.profileUrl,
        //         }).then((value) {
        //       var idCall = FirebaseHelper.getRandomString(6);
        //       CallMakeModel callMake = CallMakeModel(
        //           callId: idCall,
        //           myName: chatProvider.userInfo!.name,
        //           myPic: chatProvider.userInfo!.imageUrl,
        //           myUid: chatProvider.userInfo!.userId,
        //           dateTime: DateTime.now(),
        //           recPic: widget.profileUrl,
        //           recName: widget.userName.toString(),
        //           recUid: widget.userID,
        //           isMissed: true,
        //           isCut: false,
        //           isRec: false,
        //           callType: "audio");
        //       FirebaseHelper.sendHistory(
        //           callMake, chatProvider.callHistoryDocId!);
        //       FirebaseHelper.sendMessageNotify(
        //           senderName: chatProvider.userInfo!.name.toString(),
        //           msg: "Missed Audio Call",
        //           chatRoom: widget.chatRoom!,
        //           userID: widget.userID,
        //           image: '',
        //           voice: '');
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (_) => CallPageAudio(
        //             onCallCut: () async {
        //               await CallMethods.endCallSignleChat(
        //                   callId: chatProvider.userInfo!.userId.toString(),
        //                   recID: widget.userID);
        //             },
        //             callID: id,
        //             userID: chatProvider.userInfo!.userId!,
        //             userName: chatProvider.userInfo!.name!,
        //           ),
        //         ),
        //       );
        //     });
        //   } else {
        //     AppUtilsChats.internetDialog(context);
        //   }
        // },
        // videoCall: () async {
        //   bool isNetOn = await chatProvider.hasNetwork();
        //   if (isNetOn) {
        //     String id = FirebaseHelper.getRandomString(4);
        //     CallUtils.dialAudio(
        //         isCallPick: false,
        //         callId: id,
        //         callType: "video",
        //         // context: context,
        //         from: {
        //           "uid": chatProvider.userInfo!.userId,
        //           "name": chatProvider.userInfo!.name,
        //           "picURL": chatProvider.userInfo!.imageUrl,
        //         },
        //         to: {
        //           "uid": widget.userID,
        //           "name": widget.userName.toString(),
        //           "picURL": widget.profileUrl,
        //         }).then((value) {
        //       var idCall = FirebaseHelper.getRandomString(6);
        //       CallMakeModel callMake = CallMakeModel(
        //           callId: idCall,
        //           myName: chatProvider.userInfo!.name,
        //           myPic: chatProvider.userInfo!.imageUrl,
        //           myUid: chatProvider.userInfo!.userId,
        //           dateTime: DateTime.now(),
        //           recPic: widget.profileUrl,
        //           recName: widget.userName.toString(),
        //           recUid: widget.userID,
        //           isMissed: false,
        //           isCut: false,
        //           isRec: false,
        //           callType: "video");
        //       chatProvider.callHisoryId();
        //       FirebaseHelper.sendHistory(
        //           callMake, chatProvider.callHistoryDocId!);
        //       FirebaseHelper.sendMessageNotify(
        //           senderName: chatProvider.userInfo!.name.toString(),
        //           msg: "Missed Video Call",
        //           chatRoom: widget.chatRoom!,
        //           userID: widget.userID,
        //           image: '',
        //           voice: '');
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (_) => CallPageVideo(
        //             onCallCut: () async {
        //               await CallMethods.endCallSignleChat(
        //                   callId: chatProvider.userInfo!.userId.toString(),
        //                   recID: widget.userID);
        //             },
        //             callID: id,
        //             userID: chatProvider.userInfo!.userId!,
        //             userName: chatProvider.userInfo!.name!,
        //           ),
        //         ),
        //       );
        //     });
        //   } else {
        //     AppUtilsChats.internetDialog(context);
        //   }
        // },
        urlImage: widget.profileUrl.toString(),
        name: widget.userName.toString(),
        roomId: widget.chatRoom!.chatRoomId!,
        status: widget.showStatus.toString(),
        audioCall: (String, Stringl, List<String> n) async {
          // print('user id');
          // print(widget.userID);
          // print(widget.userName);
          // ZegoSendCallInvitationButton(
          //     isVideoCall: true,
          //     resourceID:
          //         "my_call_cloud", //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
          //     invitees: [
          //       ZegoUIKitUser(
          //         id: widget.userID,
          //         name: widget.userName,
          //       ),
          //     ]);
          // FirebaseHelper.actionButton(
          //     isVideo: false,
          //     targetUid: widget.userID,
          //     targetName: widget.userName);
          ///call make model
          bool isNetOn = await chatProvider.hasNetwork();
          if (isNetOn) {
            var idCall = FirebaseHelper.getRandomString(6);
            CallMakeModel callMake = CallMakeModel(
                callId: idCall,
                myName: chatProvider.userInfo!.name,
                myPic: chatProvider.userInfo!.imageUrl,
                myUid: chatProvider.userInfo!.userId,
                dateTime: DateTime.now(),
                recPic: widget.profileUrl,
                recName: widget.userName.toString(),
                recUid: widget.userID,
                isMissed: true,
                isCut: false,
                isRec: false,
                callType: "audio");
            FirebaseHelper.sendHistory(
                callMake, chatProvider.callHistoryDocId!);
            FirebaseHelper.sendMessageNotify(
                senderName: chatProvider.userInfo!.name.toString(),
                msg: "Missed Audio Call....",
                chatRoom: widget.chatRoom!,
                userID: widget.userID,
                image: '',
                voice: '');
          }
        },
        videoCall: (String, Stringl, List<String> n) async {
          bool isNetOn = await chatProvider.hasNetwork();
          if (isNetOn) {
            var idCall = FirebaseHelper.getRandomString(6);
            CallMakeModel callMake = CallMakeModel(
                callId: idCall,
                myName: chatProvider.userInfo!.name,
                myPic: chatProvider.userInfo!.imageUrl,
                myUid: chatProvider.userInfo!.userId,
                dateTime: DateTime.now(),
                recPic: widget.profileUrl,
                recName: widget.userName.toString(),
                recUid: widget.userID,
                isMissed: true,
                isCut: false,
                isRec: false,
                callType: "audio");
            FirebaseHelper.sendHistory(
                callMake, chatProvider.callHistoryDocId!);
            FirebaseHelper.sendMessageNotify(
                senderName: chatProvider.userInfo!.name.toString(),
                msg: "Missed Vidoe Call....",
                chatRoom: widget.chatRoom!,
                userID: widget.userID,
                image: '',
                voice: '');
          }
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chatRooms")
                  .doc(widget.chatRoom!.chatRoomId)
                  .collection('messages')
                  .orderBy("creation", descending: true)
                  .snapshots(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                    var uid = FirebaseAuth.instance.currentUser!.uid;
                    return ListView.builder(
                      reverse: true,
                      itemCount: dataSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        MessageModel messageMod = MessageModel.fromMap(
                            dataSnapshot.docs[index].data()
                                as Map<String, dynamic>);
                        return Consumer<ChatViewProvider>(
                          builder: (context, changeVal, child) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: changeVal.messagesIdLi
                                          .contains(messageMod.messageId)
                                      ? AppColors.defaultColor.withOpacity(0.3)
                                      : AppColors.transColor,
                                  borderRadius: BorderRadius.circular(8.0)),
                              // color: AppColors.defaultColor.withOpacity(0.3),
                              margin: const EdgeInsets.symmetric(vertical: 1),
                              child: GestureDetector(
                                onTap: () {
                                  if (changeVal.onTapList.isNotEmpty ||
                                      changeVal.messagesIdLi.isNotEmpty) {
                                    chatProvider.checkItemExixt(messageMod);
                                  }
                                },
                                onLongPress: () {
                                  chatProvider.checkItemExixt(messageMod);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Flex(
                                    direction: Axis.horizontal,
                                    mainAxisAlignment:
                                        (messageMod.sender == uid)
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            (messageMod.sender == uid)
                                                ? CrossAxisAlignment.end
                                                : CrossAxisAlignment.start,
                                        children: [
                                          (messageMod.image == null ||
                                                      messageMod
                                                          .image!.isEmpty) &&
                                                  (messageMod.voice == null ||
                                                      messageMod
                                                          .voice!.isEmpty) &&
                                                  (messageMod.imageText == null ||
                                                      messageMod
                                                          .imageText!.isEmpty)
                                              ? AppUtilsChats.textBox(
                                                  messageMod, uid, context)
                                              : messageMod.image!.isNotEmpty
                                                  ? ShowImageContainerTextWid(
                                                      uid: uid,
                                                      messageMod: messageMod,
                                                      sendTime: AppUtilsChats
                                                          .firebaseTimestampSingleMsg(messageMod
                                                              .creation!),
                                                      imageHol:
                                                          messageMod.image!,
                                                      imageTap: () {
                                                        if (changeVal.onTapList
                                                            .isNotEmpty) {
                                                          chatProvider
                                                              .checkItemExixt(
                                                                  messageMod);
                                                        } else {
                                                          changeVal.isSaving =
                                                              false;
                                                          changeVal.isShareImg =
                                                              false;
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (_) =>
                                                                  ShowProfileImgWid(
                                                                image:
                                                                    messageMod
                                                                        .image!,
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      color: AppColors
                                                          .defaultColor)
                                                  : messageMod.voice!.isNotEmpty
                                                      ? LocalAudioPlayerWidget(
                                                          uid,
                                                          messageMod,
                                                          messageMod.voice!,
                                                          AppUtilsChats.firebaseTimestampSingleMsg(
                                                              messageMod.creation!))
                                                      : const SizedBox(),
                                          AppUtilsChats.sizedBox(4.0, 0.0),
                                          if (index == 0)
                                            Obx(() {
                                              return imageCon.isImgSend.value
                                                  ? AppUtilsChats.imageLoader(
                                                      imageCon.imgPath.value)
                                                  : AppUtilsChats.sizedBox(
                                                      0.0, 0.0);
                                            }),
                                          if (index == 0)
                                            Obx(() {
                                              return imageCon.isVoiceSend.value
                                                  ? AppUtilsChats.voiceLoader(
                                                      context: context)
                                                  : AppUtilsChats.sizedBox(
                                                      0.0, 0.0);
                                            }),
                                          (messageMod.image == null ||
                                                      messageMod
                                                          .image!.isEmpty) &&
                                                  (messageMod.voice == null ||
                                                      messageMod
                                                          .voice!.isEmpty) &&
                                                  (messageMod.imageText ==
                                                          null ||
                                                      messageMod
                                                          .imageText!.isEmpty)
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 4.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        AppUtilsChats
                                                            .firebaseTimestampSingleMsg(
                                                                messageMod
                                                                    .creation!),
                                                        style: TextStyle(
                                                            color: (messageMod
                                                                        .sender ==
                                                                    uid)
                                                                ? AppColors
                                                                    .defaultColor
                                                                : AppColors
                                                                    .defaultColor,
                                                            fontSize: 8.0),
                                                      ),
                                                      const SizedBox(
                                                        width: 2.2,
                                                      ),
                                                      (messageMod.sender == uid)
                                                          ? const Icon(
                                                              Icons
                                                                  .done_all_sharp,
                                                              color:
                                                                  Colors.blue,
                                                              size: 12,
                                                            )
                                                          : AppUtilsChats
                                                              .sizedBox(
                                                                  0.0, 0.0)
                                                    ],
                                                  ),
                                                )
                                              : const SizedBox()
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    const Center(
                      child: Text(
                          "An error occurred! Please Check Your Internet Connection."),
                    );
                  } else {
                    const Center(
                      child: Text("NO CHAT FOUND"),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return const SizedBox();
              },
            ),
          ),

          ///text field box
          ContainerTextFieldClassWid(
            controller: message,
            onSendTap: () {
              var uid = FirebaseAuth.instance.currentUser!.uid;
              int count = widget.chatRoom!.fromMessagesCount!;
              int count1 = count + 1;
              if (widget.chatRoom!.toId == uid) {
                FirebaseHelper.sendMessage(
                    senderName: chatProvider.userInfo!.name.toString(),
                    message: message,
                    chatRoom: widget.chatRoom!,
                    userID: widget.userID,
                    fromCount: count1);
              } else {
                int count = chatProvider.countChk!;
                int increseCount = count + 1;
                FirebaseHelper.sendMessage(
                    senderName: chatProvider.userInfo!.name.toString(),
                    message: message,
                    chatRoom: widget.chatRoom!,
                    userID: widget.userID,
                    fromCount: increseCount);
              }
            },
            attachFile: () async {
              firebase_storage.Reference chatImages = firebase_storage
                  .FirebaseStorage.instance
                  .ref()
                  .child("chatImages/${DateTime.now().toIso8601String()}");
              imageCon.imgPath.value = '';
              messageImageCon.clear();

              await [
                Permission.photos,
                Permission.storage,
              ].request();
              if (!mounted) return;
              imageCon.pickImageGall(
                  context: context,
                  onSendMethod: () async {
                    Navigator.pop(context);
                    imageCon.sendImageMessage();
                    Future.delayed(const Duration(), () async {
                      UploadTask uploadTask = chatImages.putFile(
                          File(imageCon.imgPath.value),
                          SettableMetadata(
                            contentType: "image/jpeg",
                          ));
                      TaskSnapshot snapshot = await uploadTask;
                      var profileDown = await snapshot.ref.getDownloadURL();
                      var uid = FirebaseAuth.instance.currentUser!.uid;
                      int count = widget.chatRoom!.fromMessagesCount!;
                      int count1 = count + 1;
                      if (widget.chatRoom!.toId == uid) {
                        FirebaseHelper.sendImage(
                            senderName: chatProvider.userInfo!.name.toString(),
                            imagePath: profileDown,
                            text: messageImageCon.text.isEmpty
                                ? ""
                                : messageImageCon.text.trim(),
                            chatRoom: widget.chatRoom!,
                            userID: widget.userID,
                            fromCount: count1);
                      } else {
                        int count = chatProvider.countChk!;
                        int increseCount = count + 1;
                        FirebaseHelper.sendImage(
                            senderName: chatProvider.userInfo!.name.toString(),
                            imagePath: profileDown,
                            text: messageImageCon.text.isEmpty
                                ? ""
                                : messageImageCon.text.trim(),
                            chatRoom: widget.chatRoom!,
                            userID: widget.userID,
                            fromCount: increseCount);
                      }
                      // FirebaseHelper.sendImage(
                      //     senderName: widget.userName,
                      //     imagePath: profileDown,
                      //     text: messageImageCon.text.isEmpty
                      //         ? ""
                      //         : messageImageCon.text.trim(),
                      //     chatRoom: widget.chatRoom!,
                      //     userID: widget.userID,fromCount: );
                      imageCon.setSendImg(false);
                    });
                  },
                  controller: messageImageCon);
            },
            emojiPickWid: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                imageCon.openTap();
              },
              child: Obx(() {
                return Icon(
                  imageCon.isEmojiChk.value
                      ? Icons.keyboard
                      : Icons.emoji_emotions,
                  color: AppColors.defaultColor,
                );
              }),
            ),
            onFieldTap: () {
              imageCon.setEmoji();
            },
            sendRequestFunction: (File file, soundFile) async {
              firebase_storage.Reference chatVoice = firebase_storage
                  .FirebaseStorage.instance
                  .ref()
                  .child("chatVoices/${DateTime.now().toIso8601String()}");
              await imageCon.setVoiceMessage(file.path.toString());
              Future.delayed(const Duration(), () async {
                var uid = FirebaseAuth.instance.currentUser!.uid;
                int count = widget.chatRoom!.fromMessagesCount!;
                int count1 = count + 1;
                UploadTask uploadTask = chatVoice.putFile(
                    File(file.path),
                    SettableMetadata(
                      contentType: "audio/wav",
                    ));
                TaskSnapshot snapshot = await uploadTask;
                var profileDown = await snapshot.ref.getDownloadURL();
                // await sendVoice(profileDown);
                if (widget.chatRoom!.toId == uid) {
                  FirebaseHelper.sendVoice(
                      senderName: chatProvider.userInfo!.name.toString(),
                      voicePath: profileDown,
                      chatRoom: widget.chatRoom!,
                      userID: widget.userID,
                      fromCount: count1);
                } else {
                  int count = chatProvider.countChk!;
                  int increseCount = count + 1;
                  FirebaseHelper.sendVoice(
                      senderName: chatProvider.userInfo!.name.toString(),
                      voicePath: profileDown,
                      chatRoom: widget.chatRoom!,
                      userID: widget.userID,
                      fromCount: increseCount);
                }
                imageCon.setSendVoice(false);
              });
            },
          ),

          ///show emoji keyboard
          Obx(() {
            return imageCon.isEmojiChk.value
                ? ShowEmojiKeyBoard(
                    controller: message,
                  )
                : AppUtilsChats.sizedBox(0.0, 0.0);
          })
        ],
      ),
    );
  }
}
