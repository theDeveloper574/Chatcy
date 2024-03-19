import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class GetMethodController extends GetxController {
  // RxString name = "".obs;
  // RxString profileUrl = "".obs;
  RxString uid = "".obs;
  RxString textFieldVal = "".obs;
  RxString randomNum = "".obs;

  // UserModel? userModel;
  //get current user id
  Future getCurrentUserId() async {
    final User user = FirebaseAuth.instance.currentUser!;
    uid.value = user.uid.toString();
    // print(uid);
    update();
  }

  //get user specific document
  Stream<DocumentSnapshot> userDataSnapshot(String docId) {
    return FirebaseFirestore.instance
        .collection("usersProfile")
        .doc(docId)
        .snapshots();
  }

  //get users snapshot for chat
  Stream<QuerySnapshot> usersSnapshot() {
    return FirebaseFirestore.instance
        .collection("usersProfile")
        .where('userId', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  //update data users and others funcation
  Future updateCurrentData(
      {required Map<String, dynamic> updateField,
      required String userId}) async {
    await FirebaseFirestore.instance
        .collection('usersProfile')
        .doc(userId)
        .update(updateField);
  }

  ///genarate random numbers for new chats
  generate() {
    var rng = Random();
    var code = rng.nextInt(900000) + 100000;
    randomNum.value = code.toString();
    // print(randomNum.value.toString());
    update();
  }
}
