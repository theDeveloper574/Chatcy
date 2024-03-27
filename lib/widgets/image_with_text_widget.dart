import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatcy/model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';

import '../res/colors.dart';
import '../utils/utils.dart';

class ShowImageContainerTextWid extends StatelessWidget {
  final Color color;
  final Function() imageTap;
  final String imageHol;
  final String sendTime;
  final String uid;
  final MessageModel messageMod;

  const ShowImageContainerTextWid(
      {super.key,
      required this.uid,
      required this.messageMod,
      required this.color,
      required this.imageTap,
      required this.imageHol,
      required this.sendTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: messageMod.imageText!.isEmpty
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.56,
      ),
      decoration: (messageMod.sender == uid)
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
      child: Column(
        children: [
          messageMod.isForward == true
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Row(
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
                  ),
                )
              : const SizedBox(),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: GestureDetector(
                  onTap: imageTap,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: color, width: 2.8),
                    ),
                    child: ProgressiveImage(
                      fit: BoxFit.cover,
                      fadeDuration: const Duration(seconds: 5),
                      placeholder: const AssetImage('asset/image_load.gif'),
                      thumbnail: CachedNetworkImageProvider(imageHol),
                      image: CachedNetworkImageProvider(imageHol),
                      width: 200,
                      height: 300,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        sendTime,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      AppUtilsChats.sizedBox(0.0, 4.0),
                      (messageMod.sender == uid)
                          ? const Icon(
                              Icons.done_all_sharp,
                              color: Colors.blue,
                              size: 12,
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (messageMod.imageText != null && messageMod.imageText!.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
                child: Text(
                  messageMod.imageText!,
                  style: TextStyle(
                      fontSize: 14,
                      color: (messageMod.sender == uid)
                          ? AppColors.defaultColor
                          : Colors.white),
                ),
              ),
            )
        ],
      ),
    );
  }
}
