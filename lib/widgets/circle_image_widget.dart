import 'package:flutter/material.dart';

import '../res/colors.dart';

class CircleImageWidget extends StatelessWidget {
  final ImageProvider imageProvider;
  final Function() onImageChangeTap;
  final Function() onProfileChangeTap;

  const CircleImageWidget(
      {super.key,
      required this.imageProvider,
      required this.onImageChangeTap,
      required this.onProfileChangeTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onProfileChangeTap,
          child: CircleAvatar(
            backgroundColor: AppColors.sliderOneColor,
            radius: 66,
            backgroundImage: imageProvider,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onImageChangeTap,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.defaultColor,
              child: Icon(
                Icons.camera_alt,
                color: AppColors.whiteColor,
                size: 22,
              ),
            ),
          ),
        )
      ],
    );
  }
}
