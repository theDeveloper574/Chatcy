///whatsp like UI
library;

import 'package:chatcy/controllers/provider/chat_view_provider.dart';
import 'package:chatcy/controllers/services/firebase_helper_method.dart';
import 'package:chatcy/screens/status_view.dart';
import 'package:chatcy/widgets/check_call_widget.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../controllers/services/notification_service.dart';
import '../res/colors.dart';
import '../utils/routes/routes_name.dart';
import 'call_view.dart';
import 'camera_view.dart';
import 'chat_view.dart';

class HomeView extends StatefulWidget {
  int? index;
  Widget? screenNav;
  HomeView({super.key, this.index, this.screenNav});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  Widget? _child;

  @override
  void initState() {
    _child = widget.screenNav ?? const CameraView();
    // WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
    NotificationService.initialMsg(context);
    NotificationService.appForeground();
    NotificationService.appOpen();
    // });
    ChatViewProvider data =
        Provider.of<ChatViewProvider>(context, listen: false);
    data.myInfo();
    data.callHisoryId();
    data.getUserInfoPlus();
    Future.delayed(const Duration(seconds: 3), () {
      FirebaseHelper.onUserLogin(data.userInfo!.name.toString());
    });
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: widget.index ?? 0);
    _tabController!.addListener(() => _handleTabIndex());
    NotificationService.subscribeToTopic(
        FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.addListener(_handleTabIndex);
    _tabController!.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatViewProvider>(context);
    return MaterialApp(
      home: PickupLayout(
        scaffold: Scaffold(
          body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: Text(
                    "Man",
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
                  centerTitle: false,
                  automaticallyImplyLeading: false,
                  floating: true,
                  backgroundColor: AppColors.defaultColor,
                  // backgroundColor: Color.fromARGB(255, 4, 94, 84),
                  actions: [
                    const Icon(Icons.search, size: 28, color: Colors.white),
                    const SizedBox(width: 4),
                    PopupMenuButton(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        color: AppColors.whiteColor,
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        itemBuilder: (context) {
                          return const [
                            PopupMenuItem<int>(
                              value: 1,
                              child: Text("Settings"),
                            ),
                          ];
                        },
                        onSelected: (val) {
                          if (val == 1) {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(RouteName.homeSettingsView);
                          }
                        }),
                  ],
                  elevation: 0.0,
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: WhatsappTabs(50.0, _tabController!),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: const [
                // CustomScrollView(
                //   slivers: [CameraView()],
                // ),
                CustomScrollView(
                  slivers: [ChatView()],
                ),
                CustomScrollView(
                  slivers: [StatusView()],
                ),
                CustomScrollView(
                  slivers: [CallView()],
                ),
              ],
            ),
          ),
          floatingActionButton: _tabController!.index == 0
              ? FloatingActionButton(
                  shape: const CircleBorder(),
                  heroTag: "btn",
                  backgroundColor: AppColors.defaultColor,
                  onPressed: () async {
                    context.read<ChatViewProvider>().checkLi();
                    Navigator.pushNamed(context, RouteName.contact);
                  },
                  child: Icon(
                    Icons.chat,
                    color: AppColors.whiteColor,
                  ),
                )
              : _tabController!.index == 1
                  ? FloatingActionButton(
                      shape: const CircleBorder(),
                      heroTag: "status",
                      backgroundColor: AppColors.defaultColor,
                      onPressed: () async {
                        await context
                            .read<ChatViewProvider>()
                            .statusImg(context);
                      },
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: AppColors.whiteColor,
                      ),
                    )
                  : const SizedBox(),
        ),
      ),
    );
  }

  Future<List<Contact>> getContact() async {
    bool isGranted = await Permission.contacts.status.isGranted;
    if (!isGranted) {
      isGranted = await Permission.contacts.request().isGranted;
    }
    if (isGranted) {
      return await FastContacts.getAllContacts();
    }
    return [];
  }
}

class WhatsappTabs extends SliverPersistentHeaderDelegate {
  final double size;
  TabController controller;

  WhatsappTabs(this.size, this.controller);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.defaultColor,
      // color: const Color.fromARGB(255, 4, 94, 84),
      height: size,
      child: TabBar(
        controller: controller,
        indicatorWeight: 3,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white60,
        // isScrollable: true,
        tabs: const <Widget>[
          // Tab(icon: Icon(Icons.camera_alt)),
          Tab(text: "Chats"),
          Tab(text: "Status"),
          Tab(text: "Calls"),
        ],
      ),
    );
  }

  @override
  double get maxExtent => size;

  @override
  double get minExtent => size;

  @override
  bool shouldRebuild(WhatsappTabs oldDelegate) {
    return oldDelegate.size != size;
  }
}
