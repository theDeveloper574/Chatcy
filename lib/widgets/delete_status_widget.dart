import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatcy/res/colors.dart';
import 'package:flutter/material.dart';

class DeleteStatusWidget extends StatelessWidget {
  final String imageUrl;
  final Function() onShare;
  final Function() onDownload;
  final Function() onImage;
  const DeleteStatusWidget(
      {required this.imageUrl,
      required this.onShare,
      required this.onDownload,
      required this.onImage,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onImage,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 100,
                    width: 80,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Transform.scale(
                      scale: 0.7,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress,
                            color: AppColors.blueColor),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "0 views",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Now",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  )
                ],
              )
            ],
          ),
          Row(
            children: [
              InkWell(
                splashColor: Colors.grey.withOpacity(0.7),
                onTap: onDownload,
                child: CircleAvatar(
                    radius: 20.0,
                    backgroundColor: AppColors.blueColor,
                    child: const Icon(
                      Icons.download,
                      size: 18.0,
                    )),
              ),
              const SizedBox(
                width: 12.0,
              ),
              InkWell(
                splashColor: Colors.grey.withOpacity(0.7),
                onTap: onShare,
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: AppColors.blueColor,
                  child: const Icon(
                    Icons.share,
                    size: 18.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
