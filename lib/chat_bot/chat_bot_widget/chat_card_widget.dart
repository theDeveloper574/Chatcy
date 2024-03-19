import 'package:chatcy/chat_bot/ui/chat_bot_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/provider/chat_view_provider.dart';
import '../../utils/utils.dart';
import '../chat_bot_widget/gradient_text.dart';

class ChatCardWidget extends StatelessWidget {
  const ChatCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      //get colors from hex
                      Color(0xFFF69170),
                      Color(0xFF7D96E6),
                    ]),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0, left: 16.0),
                        child: (Text("Hi! You Can Ask Me",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: (Text(
                          "Anything",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 16.0, bottom: 16.0),
                        child: (TextButton(
                            onPressed: () async {
                              final chatPro = Provider.of<ChatViewProvider>(
                                  context,
                                  listen: false);
                              bool isNetOn = await chatPro.hasNetwork();
                              if (isNetOn) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ChatUiBotPage(),
                                  ),
                                );
                              } else {
                                AppUtils.internetDialog(context);
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: GradientText(
                                "Ask Now",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                gradient: LinearGradient(colors: [
                                  Color(0xFFF69170),
                                  Color(0xFF7D96E6),
                                ]),
                              ),
                            ))),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 40.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("asset/chat-logo.png"),
                            fit: BoxFit.cover),
                      ),
                      child: SizedBox(
                        height: 120,
                        width: 120,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
