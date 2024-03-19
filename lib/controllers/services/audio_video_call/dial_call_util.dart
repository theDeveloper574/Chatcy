import 'dart:math';

import 'package:chatcy/controllers/services/audio_video_call/call_service.dart';
import 'package:chatcy/model/call_model.dart';

class CallUtils {
  ///audio call done
  static Future<void> dialAudio(
      {required String callType,
      required Map from,
      required Map to,
      required String callId,
      required bool isCallPick,
      context}) async {
    // createMeeting();
    Call call = Call(
        // startTime: DateTime.now(),
        // endTime: DateTime.now(),
        // duration: '',
        callerId: from['uid'],
        callerName: from['name'],
        callerPic: from['picURL'],
        receiverId: to['uid'],
        receiverName: to['name'],
        receiverPic: to['picURL'],
        channelId: to['uid'],
        callId: callId,
        isCallPick: isCallPick,
        callType: callType);

    bool callMade = await CallMethods.makeCall(call: call);

    call.hasDialed = true;

    if (callMade) {
      var rnd = Random();
      var next = rnd.nextDouble() * 1000000;
      while (next < 100000) {
        next *= 10;
      }
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => AudioPickupScreen(
      //       call: call,
      //       // callID: next.toInt().toString(),
      //       // userid: "123",
      //       // userName: "Shani",
      //     ),
      //   ),
      // );
    }
  }
}
