import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatcy/controllers/services/audio_video_call/call_service.dart';
import 'package:chatcy/controllers/services/audio_video_call/vdieo_call_screen.dart';
import 'package:chatcy/model/call_model.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../controllers/services/audio_video_call/audio_call_screen.dart';

class PickupScreen extends StatefulWidget {
  final Call call;

  const PickupScreen({
    required this.call,
  });

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
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
  void initState() {
    // initializeAudio('asset/phone-ring.mp3');
    super.initState();
  }

  // AudioPlayer adv = AudioPlayer();
  // Future<void> initializeAudio(String audio) async {
  //   await adv.setAsset(audio);
  //   adv.setLoopMode(LoopMode.all);
  //   adv.play();
  // }

  @override
  void dispose() {
    // if (isCallMissed) {
    //   addToLocalStorage(callStatus: CALL_STATUS_MISSED);
    // }
    // adv.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image:
                  CachedNetworkImageProvider(widget.call.callerPic.toString())),
        ),
        // alignment: Alignment.center,
        // padding: const EdgeInsets.symmetric(vertical: 100),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: [
                  const Text(
                    "Incoming...",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 40),
                  CircleAvatar(
                    radius: 80,
                    backgroundImage:
                        NetworkImage(widget.call.callerPic.toString()),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    widget.call.callerName.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Colors.white),
                  ),
                ],
              ),
              // const SizedBox(height: 120),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    child: IconButton(
                      icon: const Icon(
                        Icons.call_end,
                        size: 40,
                      ),
                      color: Colors.redAccent,
                      onPressed: () async {
                        isCallMissed = false;
                        await CallMethods.endCall(call: widget.call);
                      },
                    ),
                  ),
                  const SizedBox(width: 24),
                  (widget.call.callType == "audio")
                      ? CircleAvatar(
                          radius: 30,
                          child: IconButton(
                              icon: const Icon(
                                Icons.call,
                                size: 40,
                              ),
                              color: Colors.green,
                              onPressed: () async {
                                ///try to connect call both sides
                                await CallMethods.updateCall(call: widget.call)
                                    .then((value) {
                                  // adv.stop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CallPageAudio(
                                        onCallCut: () async {
                                          isCallMissed = false;
                                          await CallMethods.endCall(
                                              call: widget.call);
                                        },
                                        callID: widget.call.callId!,
                                        userID:
                                            widget.call.receiverId.toString(),
                                        userName:
                                            widget.call.receiverName.toString(),
                                      ),
                                    ),
                                  );
                                });
                              }),
                        )
                      : CircleAvatar(
                          radius: 30,
                          child: IconButton(
                            icon: const Icon(
                              Icons.video_call,
                              size: 40,
                            ),
                            color: Colors.green,
                            onPressed: () async {
                              ///try to connect call both sides
                              await CallMethods.updateCall(call: widget.call)
                                  .then(
                                (value) {
                                  // adv.stop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CallPageVideo(
                                        onCallCut: () async {
                                          isCallMissed = false;
                                          await CallMethods.endCall(
                                              call: widget.call);
                                        },
                                        callID: widget.call.callId!,
                                        userID:
                                            widget.call.receiverId.toString(),
                                        userName:
                                            widget.call.receiverName.toString(),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
