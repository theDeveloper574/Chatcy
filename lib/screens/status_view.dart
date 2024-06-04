import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatcy/chat_bot/chat_bot_widget/chat_card_widget.dart';
import 'package:chatcy/controllers/provider/chat_view_provider.dart';
import 'package:chatcy/model/story_make_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_storyboard/flutter_instagram_storyboard.dart';
import 'package:provider/provider.dart';

import '../res/colors.dart';
import '../utils/routes/routes_name.dart';

class StatusView extends StatefulWidget {
  const StatusView({super.key});

  @override
  State<StatusView> createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  static String collectionDbName = 'instagram_stories_db';
  CollectionReference dbInstance =
      FirebaseFirestore.instance.collection(collectionDbName);
  static const double _borderRadius = 100.0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatViewProvider>();
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 1,
        (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _statusViewText(),
              Row(
                children: [
                  // _myStoriesWidget(),
                  _addStatusBut(() => provider.statusImg(context), "My Status"),
                  _storiesWidget()
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 4.0),
                child: Text(
                  "AI ChatBot",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const ChatCardWidget(),
            ],
          );
        },
      ),
    );
  }

  ///add custom buttons
  Widget _createDummyPage({
    required String imageName,
    bool addBottomBar = true,
  }) {
    return StoryPageScaffold(
      // bottomNavigationBar: addBottomBar
      //     ? SizedBox(
      //         width: double.infinity,
      //         height: kBottomNavigationBarHeight,
      //         child: Padding(
      //           padding: const EdgeInsets.symmetric(
      //             vertical: 8.0,
      //             horizontal: 20.0,
      //           ),
      //           child: Row(
      //             children: [
      //               Expanded(
      //                 child: Container(
      //                   width: double.infinity,
      //                   height: double.infinity,
      //                   decoration: BoxDecoration(
      //                     border: Border.all(
      //                       color: Colors.white,
      //                       width: 2.0,
      //                     ),
      //                     borderRadius: BorderRadius.circular(
      //                       _borderRadius,
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //               const Padding(
      //                 padding: EdgeInsets.all(8.0),
      //                 child: Icon(
      //                   Icons.send,
      //                   color: Colors.white,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       )
      //     : const SizedBox.shrink(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              imageName,
            ),
            fit: BoxFit.cover,
          ),
        ),
        // child: Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20),
        //   child: Column(
        //     mainAxisSize: MainAxisSize.max,
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       Text(
        //         text,
        //         style: const TextStyle(
        //           color: Colors.white,
        //           fontSize: 30.0,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       )
        //     ],
        //   ),
        // ),
      ),
    );
  }

  Widget _buildButtonChild(String text) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 104.0,
          ),
          Text(
            text,
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 14.0,
                overflow: TextOverflow.ellipsis),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildButtonDecoration(String userProfile) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(_borderRadius),
      image: DecorationImage(
        image: CachedNetworkImageProvider(
          userProfile,
        ),
        fit: BoxFit.cover,
      ),
    );
  }

  BoxDecoration _buildBorderDecoration(Color color) {
    return BoxDecoration(
      borderRadius: const BorderRadius.all(
        Radius.circular(_borderRadius),
      ),
      border: Border.fromBorderSide(
        BorderSide(
          color: color,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _statusViewText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 4.0),
          child: Text(
            "Status",
            style: TextStyle(fontSize: 20),
          ),
        ),
        PopupMenuButton(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          constraints: const BoxConstraints.expand(width: 150, height: 60),
          position: PopupMenuPosition.under,
          color: AppColors.whiteColor,
          icon: const Icon(
            Icons.more_vert,
          ),
          itemBuilder: (context) {
            return const [
              PopupMenuItem<int>(
                value: 1,
                child: Center(
                  child: Text("View my status"),
                ),
              ),
            ];
          },
          onSelected: (val) {
            if (val == 1) {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(RouteName.deleteStatus);
            }
          },
        ),
      ],
    );
  }

  ///view users story widget
  Widget _storiesWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("story")
          .where('userUid',
              isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(left: 38.0, bottom: 38),
            child: Text(
              'No STATUS FOUND.',
              textAlign: TextAlign.center,
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            QuerySnapshot snap = snapshot.data as QuerySnapshot;
            return Expanded(
              flex: 2,
              child: StoryListView(
                listHeight: 160.0,
                buttonWidth: 100,
                paddingTop: 0.0,
                pageTransform: const StoryPage3DTransform(),
                buttonDatas: List.generate(snap.docs.length, (index) {
                  StoryMakeModel storiesCount = StoryMakeModel.fromJson(
                      snap.docs[index].data() as Map<String, dynamic>);
                  return StoryButtonData(
                    timelineBackgroundColor: AppColors.colorsList[index],
                    buttonDecoration:
                        _buildButtonDecoration(storiesCount.profileUrl!),
                    child: _buildButtonChild(storiesCount.name!),
                    borderDecoration:
                        _buildBorderDecoration(AppColors.colorsList[index]),
                    storyPages:
                        List.generate(storiesCount.storyImage!.length, (index) {
                      return _createDummyPage(
                          imageName: storiesCount.storyImage![index],
                          addBottomBar: false);
                    }),
                    segmentDuration: const Duration(seconds: 3),
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

  ///view my stories if not null
  Widget _myStoriesWidget() {
    final provider = context.watch<ChatViewProvider>();
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("story")
          .where('userUid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return _addStatusBut(() => provider.statusImg(context), "My Status");
        }
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            QuerySnapshot snap = snapshot.data as QuerySnapshot;
            return Expanded(
              child: StoryListView(
                listHeight: 160.0,
                buttonWidth: 100,
                paddingTop: 0.0,
                pageTransform: const StoryPage3DTransform(),
                buttonDatas: List.generate(snap.docs.length, (index) {
                  StoryMakeModel storiesCount = StoryMakeModel.fromJson(
                      snap.docs[index].data() as Map<String, dynamic>);
                  return StoryButtonData(
                    timelineBackgroundColor: AppColors.colorsList[index],
                    buttonDecoration:
                        _buildButtonDecoration(storiesCount.profileUrl!),
                    child: _buildButtonChild("My Status"),
                    borderDecoration:
                        _buildBorderDecoration(AppColors.colorsList[index]),
                    storyPages:
                        List.generate(storiesCount.storyImage!.length, (index) {
                      return _createDummyPage(
                          imageName: storiesCount.storyImage![index],
                          addBottomBar: false);
                    }),
                    segmentDuration: const Duration(seconds: 3),
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

  Widget _addStatusBut(Function()? onStoryTap, String name) {
    return GestureDetector(
      onTap: onStoryTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 34.0, left: 14.0, right: 14.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Consumer<ChatViewProvider>(
                  builder: (context, value, child) {
                    return CircleAvatar(
                      radius: 48.0,
                      backgroundImage: CachedNetworkImageProvider(
                        value.photoURL,
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 16.0,
                    backgroundColor: AppColors.blueColor,
                    child: Icon(
                      Icons.add,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                name,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.0,
                    overflow: TextOverflow.ellipsis),
              ),
            )
          ],
        ),
      ),
    );
  }
}
