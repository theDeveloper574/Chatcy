import 'package:chatcy/model/call_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CallMethods {
  static final CollectionReference callCollection =
      FirebaseFirestore.instance.collection('call');

  Stream<DocumentSnapshot> callStream({required String uid}) =>
      callCollection.doc(uid).snapshots();

  static Future<bool> makeCall({required Call call}) async {
    try {
      call.hasDialed = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialed = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await callCollection.doc(call.callerId).set(hasDialledMap);
      await callCollection.doc(call.receiverId).set(hasNotDialledMap);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  static Future<bool> endCall({required Call call}) async {
    try {
      await callCollection.doc(call.callerId).delete();
      await callCollection.doc(call.receiverId).delete();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  static Future<bool> updateCall({required Call call}) async {
    try {
      await callCollection.doc(call.callerId).update({"is_call_pick": true});
      await callCollection.doc(call.receiverId).update({"is_call_pick": true});
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  ///try to delete the docs
  static Future<bool> endCallSignleChat(
      {required String callId, required String recID}) async {
    try {
      await callCollection.doc(callId).delete();
      await callCollection.doc(recID).delete();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('e print');
        print(e);
      }
      return false;
    }
  }
}
