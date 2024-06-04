import 'dart:convert';

import 'package:chatcy/res/colors.dart';
import 'package:chatcy/utils/utils.dart';
import 'package:chatcy/widgets/text_dot_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../controllers/provider/chat_view_provider.dart';

class ChatUiBotPage extends StatefulWidget {
  const ChatUiBotPage({super.key});

  @override
  State<ChatUiBotPage> createState() => _ChatUiBotPageState();
}

class _ChatUiBotPageState extends State<ChatUiBotPage> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _chatHistory = [];
  @override
  void initState() {
    // TODO: implement initState
    _chatHistory.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.blueColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Chat",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          _chatHistory.isEmpty
              ? const Expanded(
                  child: Center(
                    child: Text(
                      "ASK ANYTHING TO CHAT BOT CHAT BOT!!!",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _chatHistory.length + (isWaiting ? 1 : 0),
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    itemBuilder: (context, index) {
                      if (index == _chatHistory.length) {
                        // Display "Replying..." while waiting for API response
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          alignment: Alignment.topLeft,
                          child: const DotDotDotAnimation(),
                          // child: const Text(
                          //   "typing...",
                          //   style: TextStyle(fontSize: 15, color: Colors.grey),
                          // ),
                        );
                      } else {
                        // Display API response or user message
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14.0,
                            vertical: 10.0,
                          ),
                          child: Align(
                            alignment: (_chatHistory[index]["isSender"]
                                ? Alignment.topRight
                                : Alignment.topLeft),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                color: (_chatHistory[index]["isSender"]
                                    ? AppColors.blueColor
                                    // ? const Color(0xFFF69170)
                                    : Colors.white),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                _chatHistory[index]["message"],
                                style: TextStyle(
                                  fontSize: _chatHistory[index]["isSender"]
                                      ? 14.0
                                      : 16.0,
                                  color: _chatHistory[index]["isSender"]
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            height: 66.0,
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      border: GradientBoxBorder(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFF69170),
                              Color(0xFF7D96E6),
                            ]),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 6.0),
                      ),
                      controller: _chatController,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 4.0,
                ),
                MaterialButton(
                  onPressed: () async {
                    ///check internet connection
                    final chatPro =
                        Provider.of<ChatViewProvider>(context, listen: false);
                    bool isNetOn = await chatPro.hasNetwork();
                    if (isNetOn) {
                      setState(() {
                        if (_chatController.text.isNotEmpty) {
                          // sendMessage();
                          _chatHistory.add({
                            "time": DateTime.now(),
                            "message": _chatController.text,
                            "isSender": true,
                          });
                          _chatController.clear();
                        }
                      });
                      scrollToEnd();
                    } else {
                      AppUtilsChats.internetDialog(context);
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  padding: const EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFF69170),
                            Color(0xFF7D96E6),
                          ]),
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    ),
                    child: Container(
                        constraints: const BoxConstraints(
                            minWidth: 88.0, minHeight: 36.0),
                        // min sizes for Material buttons
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        )),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  bool isWaiting = false;
  void getAnswer() async {
    final uri = Uri.parse(urlChatBot);
    List<Map<String, String>> msg = [];
    for (var i = 0; i < _chatHistory.length; i++) {
      msg.add({"content": _chatHistory[i]["message"]});
    }
    Map<String, dynamic> request = {
      "prompt": {
        "messages": [msg]
      },
      "temperature": 0.25,
      "candidateCount": 1,
      "topP": 1,
      "topK": 1
    };
    isWaiting = true;
    final response = await http.post(uri, body: jsonEncode(request));
    if (response.statusCode == 200) {
      setState(() {
        _chatHistory.add({
          "time": DateTime.now(),
          "message": json.decode(response.body)["candidates"][0]["content"],
          "isSender": false,
        });
      });
      isWaiting = false;
    } else {
      Get.snackbar("ChatCY", response.body);
    }
  }

  void scrollToEnd() {
    getAnswer();
    scrollToBottom(_scrollController);
  }

  Future scrollToBottom(ScrollController scrollController) async {
    if (_scrollController.hasClients) {
      while (scrollController.position.pixels !=
          scrollController.position.maxScrollExtent) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
        await SchedulerBinding.instance.endOfFrame;
      }
    }
  }
}
