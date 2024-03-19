import 'package:flutter/material.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 1,
            (context, index) {
          return const Center(
            child: Text("Coming soon..."),
          );
        },
      ),
    );
  }
}