import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatcy/controllers/services/audio_video_call/call_service.dart';
import 'package:chatcy/model/call_model.dart';
import 'package:flutter/material.dart';

class CallingWidget extends StatefulWidget {
  final Call call;

  const CallingWidget({
    required this.call,
  });

  @override
  _CallingWidgetState createState() => _CallingWidgetState();
}

class _CallingWidgetState extends State<CallingWidget> {
  // final CallMethods callMethods = CallMethods();

  // final LogRepository logRepository = LogRepository(isHive: true);
  // final LogRepository logRepository = LogRepository(isHive: false);

  bool isCallMissed = true;

  // addToLocalStorage({@required String callStatus}) {
  //   Log log = Log(
  //     callerName: widget.call.callerName,
  //     callerPic: widget.call.callerPic,
  //     receiverName: widget.call.receiverName,
  //     receiverPic: widget.call.receiverPic,
  //     timestamp: DateTime.now().toString(),
  //     callStatus: callStatus,
  //   );
  //
  //   // LogRepository.addLogs(log);
  // }

  @override
  void dispose() {
    // if (isCallMissed) {
    //   addToLocalStorage(callStatus: CALL_STATUS_MISSED);
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          constraints: const BoxConstraints.expand(),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(
                widget.call.receiverPic.toString(),
              ),
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: [
                    const Text(
                      "Calling...",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 40),
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: CachedNetworkImageProvider(
                          widget.call.receiverPic.toString()),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      widget.call.receiverName.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: Colors.white),
                    ),
                  ],
                ),
                // const SizedBox(height: 120),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: IconButton(
                    icon: const Icon(
                      Icons.call_end,
                      size: 40,
                    ),
                    color: Colors.redAccent,
                    onPressed: () async {
                      isCallMissed = false;
                      // Get.back();
                      await CallMethods.endCall(call: widget.call);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
