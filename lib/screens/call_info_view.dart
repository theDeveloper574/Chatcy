import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatcy/screens/chat_view.dart';
import 'package:chatcy/screens/home_view.dart';
import 'package:flutter/material.dart';

import '../model/call_make_model.dart';
import '../res/colors.dart';
import '../utils/utils.dart';
import '../widgets/call_info_detail_wid.dart';

class CallInfoView extends StatelessWidget {
  final CallMakeModel callDetail;
  const CallInfoView(this.callDetail, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.defaultColor,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Call info",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomeView(
                        index: 0,
                        screenNav: const ChatView(),
                      ),
                    ),
                    (route) => false);
              },
              child: const Icon(Icons.chat)),
          AppUtils.sizedBox(0.0, 20.0),
          // PopupMenuButton(
          //     padding: EdgeInsets.zero,
          //     constraints: const BoxConstraints.expand(width: 190, height: 110),
          //     icon: const Icon(
          //       Icons.more_vert,
          //       color: Colors.white,
          //     ),
          //     itemBuilder: (context) {
          //       return const [
          //         PopupMenuItem<int>(
          //           value: 1,
          //           child: Text("Remove from call log"),
          //         ),
          //         PopupMenuItem<int>(
          //           value: 2,
          //           child: Text("Block"),
          //         ),
          //       ];
          //     },
          //     onSelected: (val) {
          //       FocusManager.instance.primaryFocus!.unfocus();
          //     }),
        ],
      ),
      body: Column(
        children: [
          CallInfoDetailAndProfileWidget(
            onListTap: () {},
            nameTitle: callDetail.recName!,
            about: "Hello, I'm using MaanApp",
            imageProvider: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(callDetail.recPic!),
              radius: 24,
            ),
            audioCallWid: callDetail.callType == "audio"
                ? Icon(
                    Icons.phone,
                    color: AppColors.defaultColor,
                  )
                : Icon(
                    Icons.video_camera_back,
                    color: AppColors.defaultColor,
                  ),
            videoCallWid: const SizedBox(),
          ),
          Divider(
            indent: 80,
            height: 0.0,
            color: AppColors.defaultColor.withOpacity(0.2),
            thickness: 0.8,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: callDetail.isMissed == true
                  ? const Icon(
                      Icons.call_made,
                      color: Colors.red,
                      size: 18,
                    )
                  : const Icon(
                      Icons.call_received,
                      color: Colors.green,
                      size: 18,
                    ),
            ),
            title: Text(
              callDetail.isMissed == true ? "Outgoing" : 'Incoming',
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black54),
            ),
            subtitle: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.call,
                  size: 18,
                ),
                AppUtils.sizedBox(0.0, 12.0),
                Text(
                  AppUtils.callHistoryTime(callDetail.dateTime!),
                )
              ],
            ),
            trailing: Text(
              callDetail.isMissed == false ? "Not answered" : 'answered',
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black45),
            ),
          )
        ],
      ),
    );
  }
}
