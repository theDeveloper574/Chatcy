import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/utils.dart';

class CallInfoDetailAndProfileWidget extends StatelessWidget {
  final Widget imageProvider;
  final String nameTitle;
  final String about;
  final Widget audioCallWid;
  final Widget videoCallWid;
  final Function() onListTap;

  const CallInfoDetailAndProfileWidget(
      {super.key,
      required this.imageProvider,
      required this.nameTitle,
      required this.about,
      required this.audioCallWid,
      required this.videoCallWid,
      required this.onListTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onListTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 1.0),
      leading: imageProvider,
      title: Text(
        nameTitle,
        style: GoogleFonts.roboto(
            fontSize: 18,
            textStyle: const TextStyle(fontWeight: FontWeight.w500)),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Text(
          about,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppUtils.sizedBox(0.0, 8),
          audioCallWid,
          AppUtils.sizedBox(0.0, 22),
          videoCallWid
        ],
      ),
    );
  }
}

///my-profile-widget class
class ProfileWidget extends StatelessWidget {
  final Widget imageProvider;
  final String nameTitle;
  final String about;
  final Widget audioCallWid;
  final Widget videoCallWid;
  final Function() onListTap;

  const ProfileWidget(
      {super.key,
      required this.imageProvider,
      required this.nameTitle,
      required this.about,
      required this.audioCallWid,
      required this.videoCallWid,
      required this.onListTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onListTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      leading: imageProvider,
      title: Text(
        nameTitle,
        style: GoogleFonts.roboto(
            fontSize: 14,
            textStyle: const TextStyle(
                fontWeight: FontWeight.w500, color: Colors.grey)),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Text(
          about,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // AppUtils.sizedBox(0.0, 8),
          audioCallWid,
          // Icon(
          //   Icons.phone,
          //   color: AppColors.defaultColor,
          // ),
          // AppUtils.sizedBox(0.0, 22),
          videoCallWid
          // Icon(
          //   Icons.video_camera_back,
          //   color: AppColors.defaultColor,
          // ),
        ],
      ),
    );
  }
}
