import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../res/colors.dart';

class ViewStatusImage extends StatefulWidget {
  final String image;
  const ViewStatusImage({super.key, required this.image});
  @override
  State<ViewStatusImage> createState() => _ViewStatusImageState();
}

class _ViewStatusImageState extends State<ViewStatusImage> {
  final TransformationController _transformationController =
      TransformationController();

  TapDownDetails? _doubleTapDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.whiteColor),
        backgroundColor: Colors.black,
      ),
      body: GestureDetector(
        onDoubleTapDown: (d) => _doubleTapDetails = d,
        onDoubleTap: _handleDoubleTap,
        child: Container(
          color: Colors.black,
          height: double.infinity,
          width: double.infinity,
          child: InteractiveViewer(
            transformationController: _transformationController,
            minScale: 0.9,
            maxScale: 4,
            child:
                CachedNetworkImage(imageUrl: widget.image, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails!.localPosition;
      // For a 3x zoom
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
      // Fox a 2x zoom
      // ..translate(-position.dx, -position.dy)
      // ..scale(2.0);
    }
  }
}
