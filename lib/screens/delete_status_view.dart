import 'dart:io';
import 'dart:typed_data';

import 'package:chatcy/model/story_make_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../controllers/provider/chat_view_provider.dart';
import '../widgets/delete_status_widget.dart';
import '../widgets/view_my_status_image_widget.dart';

class DeleteStatusView extends StatefulWidget {
  const DeleteStatusView({super.key});

  @override
  State<DeleteStatusView> createState() => _DeleteStatusViewState();

  static const double _borderRadius = 100.0;
}

class _DeleteStatusViewState extends State<DeleteStatusView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "My Status",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.0, vertical: 12.0),
            child: Text(
              "My Story",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          _myStoriesWidget(),
          // DeleteStatusWidget(),
        ],
      ),
    );
  }

  ///try to get all user stories
  Widget _myStoriesWidget() {
    final provider = context.watch<ChatViewProvider>();
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("story")
          .where('userUid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          const Center(
            child: Text("NO STORIES FOUND"),
          );
        }
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            QuerySnapshot snap = snapshot.data as QuerySnapshot;
            return Expanded(
              child: Column(
                children: List.generate(snap.docs.length, (index) {
                  StoryMakeModel storiesCount = StoryMakeModel.fromJson(
                      snap.docs[index].data() as Map<String, dynamic>);
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: storiesCount.storyImage!.length,
                    itemBuilder: (context, int index) {
                      var docs = storiesCount.storyImage![index];
                      return DeleteStatusWidget(
                        onImage: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewStatusImage(
                                image: docs,
                              ),
                            ),
                          );
                        },
                        imageUrl: docs,
                        onShare: () async {
                          await shareImage(url: docs);
                        },
                        onDownload: () {
                          saveImage(docs).then((value) {
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.success,
                                barrierDismissible: false,
                                title: 'Success!',
                                text: 'Image Saved Successfully');
                          });
                        },
                      );
                    },
                  );
                }),
              ),
            );
          }
        }
        return const SizedBox();
      },
    );
  }

  ///share my story
  Future<void> shareImage({required String url}) async {
    final response = await get(Uri.parse(url));
    final directory = await getTemporaryDirectory();
    File file = await File('${directory.path}/Image.png')
        .writeAsBytes(response.bodyBytes);

    await Share.shareXFiles([XFile(file.path)], text: 'Share');
  }

  ///download my story
  Future<void> saveImage(String url) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    await requestPermission(Permission.storage);
    var response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
        name: 'story$time');
  }
}
