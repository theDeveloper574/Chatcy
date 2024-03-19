import 'dart:convert';

import 'package:chatcy/res/colors.dart';
import 'package:chatcy/screens/chat_view.dart';
import 'package:chatcy/screens/home_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  ///iniliaze notification
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @pragma('vm:entry-point')
  static void NotiRes(NotificationResponse res) async {
    Get.to(
      () => HomeView(
        index: 1,
        screenNav: const ChatView(),
      ),
    );
  }

  @pragma('vm:entry-point')
  static void resNotifi(NotificationResponse res) async {
    Get.to(
      () => HomeView(
        index: 1,
        screenNav: const ChatView(),
      ),
    );
  }

  static void initialize() {
    // initializationSettings  for Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("logo"),
      // android: AndroidInitializationSettings("ic_launcher"),
    );
    _notificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: NotiRes,
        onDidReceiveNotificationResponse: resNotifi);
  }

  ///send notification to the user
  static Future<void> sendNotifi(
      {required String title,
      required String body,
      required String uid}) async {
    final data = {
      "to": "/topics/$uid",
      "notification": {"title": body, "body": title},
      "data": {
        "type": "Order",
        "id": "28",
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      }
    };
    final headers = {
      "content-type": "application/json",
      "Authorization": "key=$serverKey"
    };

    var res = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: headers);
    if (res.statusCode == 200) {
      if (kDebugMode) {
        print('notification has sent');
      }
      if (kDebugMode) {
        print(res.body);
      }
    } else {
      if (kDebugMode) {
        print('notification not sent');
        print(res.body);
      }
    }
  }

  ///handle received notification
  static void createDisNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "com.chatcy",
          "com.chatcychannel",
          // icon: "ic_launcher",
          icon: "logo",
          playSound: true,
          enableLights: true,
          enableVibration: true,
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['_id'],
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  ///subscribe to topic
  static Future<void> subscribeToTopic(String topic) async {
    // if (kDebugMode) {
    //   print('subscribe topic success');
    // }
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  ///un-subscribe to topic
  static Future<void> unSubscribeToTopic(String topic) async {
    if (kDebugMode) {
      print('un-subscribe topic success');
    }
    FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  //handle background message
  static Future<void> backgroundHandler(RemoteMessage message) async {
    if (kDebugMode) {
      print(message.data.toString());
      print(message.notification!.title);
    }
  }

  //handkle background messages
  static Future<void> initialMsg(context) async {
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        if (kDebugMode) {
          print("FirebaseMessaging.instance.getInitialMessage");
        }
        if (message != null) {
          if (message.data['_id'] != null) {
            Get.to(
              () => HomeView(
                index: 1,
                screenNav: const ChatView(),
              ),
            );
          }
        }
      },
    );
  }

  // 2. This method only call when App in forground it mean app must be opened
  static Future<void> appForeground() async {
    FirebaseMessaging.onMessage.listen(
      (message) {
        if (kDebugMode) {
          print("FirebaseMessaging.onMessage.listen");
        }
        if (message.notification != null) {
          if (kDebugMode) {
            print(message.notification!.title);
            print(message.notification!.body);
            print("message.data11 ${message.data}");
          }
          createDisNotification(message);
        }
      },
    );
  }

  // 3. This method only call when App in background and not terminated(not closed)
  static Future<void> appOpen() async {
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        if (kDebugMode) {
          print("FirebaseMessaging.onMessageOpenedApp.listen");
        }
        if (message.notification != null) {
          if (kDebugMode) {
            print(message.notification!.title);
            print(message.notification!.body);
            print("message.data22 ${message.data['_id']}");
          }
        }
      },
    );
  }
}
