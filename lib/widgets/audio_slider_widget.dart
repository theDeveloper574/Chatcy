// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:chatcy/model/message_model.dart';
import 'package:chatcy/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class LocalAudioPlayerWidget extends StatefulWidget {
  String uid;
  String audioUrl;
  MessageModel messageMod;
  // Decoration decoration;
  String datetime;
  LocalAudioPlayerWidget(
    this.uid,
    this.messageMod,
    this.audioUrl,
    this.datetime, {
    super.key,
  });

  @override
  LocalAudioPlayerWidgetState createState() => LocalAudioPlayerWidgetState();
}

class LocalAudioPlayerWidgetState extends State<LocalAudioPlayerWidget> {
  final AudioPlayer _player = AudioPlayer();
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    // Load the audio URL when the widget initializes
    // _player.setUrl(widget.audioUrl);

    // Listen for audio completion event
    _player.positionStream.listen((position) {
      final duration = _player.duration;
      if (duration != null && position >= duration) {
        if (mounted) {
          setState(() {
            isCompleted = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isCompleted = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.audioUrl.isNotEmpty
        ? Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.09,
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
            decoration: (widget.messageMod.sender == widget.uid)
                ? BoxDecoration(
                    border: Border.all(
                      color: AppColors.defaultColor.withOpacity(0.01),
                    ),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 0.01,
                          blurRadius: 0.01,
                          blurStyle: BlurStyle.solid)
                    ],
                    color: Colors.white,
                    // border: Border.all(
                    //   color: Colors.grey,
                    // ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  )
                : BoxDecoration(
                    color: AppColors.defaultColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
            child: FittedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.messageMod.isForward == true
                      ? Row(
                          children: [
                            Image.asset(
                              "asset/forword_Icon.png",
                              scale: 28.0,
                              color: Colors.grey,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 2.0),
                              child: Text(
                                "Forwarded",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  Row(
                    children: [
                      // Play Button
                      IconButton(
                        icon: Icon(
                          isCompleted
                              ? Icons.play_arrow
                              : _player.playing
                                  ? Icons.pause
                                  : Icons.play_arrow,
                          // color: Colors.white,
                          color: (widget.messageMod.sender == widget.uid)
                              ? AppColors.blueColor
                              : AppColors.whiteColor,
                          size: 24,
                        ),
                        onPressed: () async {
                          if (isCompleted) {
                            _player.seek(Duration.zero);
                          }
                          if (_player.playing) {
                            _player.pause();
                          } else {
                            _player.setUrl(widget.audioUrl);
                            _player.play();
                          }
                          if (mounted) {
                            setState(() {});
                          } // Update the UI to reflect the state
                        },
                      ),
                      // Progress Bar
                      StreamBuilder<Duration?>(
                        stream: _player.durationStream,
                        builder: (context, snapshot) {
                          final duration = snapshot.data ?? Duration.zero;
                          return StreamBuilder<Duration>(
                            stream: _player.positionStream,
                            builder: (context, snapshot) {
                              var position = snapshot.data ?? Duration.zero;
                              if (position > duration) {
                                position = duration;
                              }
                              return Transform.scale(
                                scale: 0.9,
                                child: SliderTheme(
                                  data: SliderThemeData(
                                    thumbColor:
                                        (widget.messageMod.sender == widget.uid)
                                            ? AppColors.blueColor
                                            : AppColors.whiteColor,
                                    thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 8.0),
                                  ),
                                  child: Slider(
                                    value: isCompleted
                                        ? 0
                                        : position.inSeconds.toDouble(),
                                    onChanged: (value) {
                                      _player.seek(
                                        Duration(
                                          seconds: value.toInt(),
                                        ),
                                      );
                                    },
                                    min: 0.0,
                                    max: duration.inSeconds.toDouble(),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      Text(
                        widget.datetime,
                        style: TextStyle(
                          fontSize: 10,
                          color: (widget.messageMod.sender == widget.uid)
                              ? AppColors.defaultColor
                              : Colors.white,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}
