import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';

import '../controllers/messages_controllers.dart';
import '../res/colors.dart';

class ContainerTextFieldClassWid extends StatefulWidget {
  // const ContainerTextFieldClassWid({super.key});

  final TextEditingController controller;
  final Function() onSendTap;
  final Function() attachFile;
  final Widget emojiPickWid;
  final Function() onFieldTap;
  final Function(File, String) sendRequestFunction;
  const ContainerTextFieldClassWid(
      {super.key,
      required this.controller,
      required this.onSendTap,
      required this.attachFile,
      required this.emojiPickWid,
      required this.onFieldTap,
      required this.sendRequestFunction});

  @override
  State<ContainerTextFieldClassWid> createState() =>
      _ContainerTextFieldClassWidState();
}

class _ContainerTextFieldClassWidState
    extends State<ContainerTextFieldClassWid> {
  MessageControllers message = Get.put(MessageControllers());
  // TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(color: Colors.white)),
                child: Column(
                  children: [
                    // if(isReplying) buildReply(chatRoomProvider),
                    TextFormField(
                      onTap: widget.onFieldTap,
                      onChanged: (val) {
                        setState(() {});
                      },
                      controller: widget.controller,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return '';
                        }
                        return null;
                      },
                      maxLines: 3,
                      minLines: 1,
                      cursorColor: Colors.grey,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Type message here',
                        hintStyle: const TextStyle(color: Colors.grey),
                        // border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 2),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.09))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.09))),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        suffixIcon: widget.emojiPickWid,
                        prefixIcon: IconButton(
                          icon: Icon(
                            Icons.attach_file,
                            color: AppColors.defaultColor,
                          ),
                          onPressed: widget.attachFile,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          widget.controller.text.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // const SizedBox(
                    //   height: 16.0,
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 0.0),
                      child: SocialMediaRecorder(
                        // counterBackGroundColor: Colors.red,
                        cancelTextBackGroundColor: Colors.white,
                        counterTextStyle: const TextStyle(color: Colors.red),
                        recordIcon: Icon(
                          Icons.mic,
                          color: AppColors.defaultColor,
                          size: 30,
                        ),
                        backGroundColor: AppColors.transColor,
                        recordIconWhenLockBackGroundColor:
                            AppColors.defaultColor,
                        recordIconBackGroundColor: AppColors.whiteColor,
                        cancelTextStyle: const TextStyle(color: Colors.red),
                        slideToCancelTextStyle: const TextStyle(
                            color: Colors.white, fontSize: 16.0),
                        // radius: BorderRadius.circular(2.0),
                        sendRequestFunction: widget.sendRequestFunction,
                        // sendRequestFunction: (File file, soundFile) async {
                        //   // ref.watch(handleAud).path = soundFile.path.toString();
                        //   // await chatRoomProvider.postVoiceMessage(length, soundFile, authProvider);
                        //   await message.setVoiceMessage(file.path.toString());
                        // },
                        encode: AudioEncoderType.AAC,
                      ),
                    ),
                  ],
                )
              : MaterialButton(
                  minWidth: 20.0,
                  height: 40.0,
                  onPressed: () {
                    widget.onSendTap();
                    widget.controller.clear();
                    setState(() {});
                  },
                  shape: const CircleBorder(),
                  color: AppColors.defaultColor,
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
        ],
      ),
    );
  }
}
