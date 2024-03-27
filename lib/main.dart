import 'package:chatcy/res/colors.dart';
import 'package:chatcy/utils/routes/routes_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import 'controllers/provider/call_his_load_more.dart';
import 'controllers/provider/chat_view_provider.dart';
import 'controllers/services/notification_service.dart';
import 'firebase_options.dart';
import 'utils/routes/route.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(NotificationService.backgroundHandler);
  // runApp(const MyApp());
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  ZegoUIKit().initLog().then((value) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ChatViewProvider>(
              create: (_) => ChatViewProvider()),
          ChangeNotifierProvider<CallHisLoadMore>(
              create: (_) => CallHisLoadMore()),
        ],
        child: MyApp(
          navigatorKey: navigatorKey,
        ),
      ),
    );
  });
}
// runApp(
//   MultiProvider(
//     providers: [
//       ChangeNotifierProvider<ChatViewProvider>(
//           create: (_) => ChatViewProvider()),
//       ChangeNotifierProvider<CallHisLoadMore>(
//           create: (_) => CallHisLoadMore()),
//     ],
//     child: const MyApp(),
//   ),
// );
// }

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({super.key, required this.navigatorKey});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of your application.

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FirebaseAuth.instance.currentUser != null
          ? setStatus("online", FirebaseAuth.instance.currentUser!.uid)
          : null;
    } else {
      FirebaseAuth.instance.currentUser != null
          ? setStatus("offline", FirebaseAuth.instance.currentUser!.uid)
          : null;
      //offline user
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: widget.navigatorKey,
      theme: ThemeData(
        fontFamily: 'roboto',
        appBarTheme: AppBarTheme(
            elevation: 0.0, backgroundColor: AppColors.defaultColor),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: AppColors.lightGreen),
      ),

      ///default route
      // home: FirebaseAuth.instance.currentUser != null
      //     ? const LogInView()
      //     : HomeView(),
      initialRoute: RouteName.splash,
      onGenerateRoute: Routes.generateRoute,
    );
  }

  void setStatus(String status, String uid) {
    FirebaseFirestore.instance
        .collection("usersProfile")
        .doc(uid)
        .update({"status": status});
  }
}

Future flutterToast({required String message}) {
  return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.defaultColor,
      textColor: Colors.white,
      fontSize: 14.0);
}
