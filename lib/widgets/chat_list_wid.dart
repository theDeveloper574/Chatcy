import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../res/colors.dart';
import '../utils/utils.dart';

class ChatListAndCallWidget extends StatelessWidget {
  final Function() onTap;
  final Widget iconWidget;
  final String msgOrCallTime;
  final String userName;
  final Widget widget;
  final String imageProfile;
  final Color textColor;
  final FontWeight textFontWei;

  const ChatListAndCallWidget(
      {super.key,
      required this.iconWidget,
      required this.onTap,
      required this.msgOrCallTime,
      required this.userName,
      required this.widget,
      required this.imageProfile,
      required this.textColor,
      required this.textFontWei});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: 0.0),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: AppColors.defaultColor,
        backgroundImage: CachedNetworkImageProvider(imageProfile),
        radius: 24,
        // backgroundImage: contact.,
      ),
      title: Text(
        userName,
        style: GoogleFonts.roboto(
          textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
              fontSize: 18),
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            AppUtilsChats.sizedBox(0.0, 4.0),
            Flexible(
              child: Text(
                msgOrCallTime,
                style: TextStyle(
                    fontSize: 14.0,
                    color: textColor,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: textFontWei),
              ),
            ),
          ],
        ),
      ),
      trailing: widget,
    );
  }
}
