import 'dart:io';

import 'package:chatcy/controllers/provider/chat_view_provider.dart';
import 'package:chatcy/controllers/services/database_collection.dart';
import 'package:chatcy/controllers/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';

import '../model/contacts_model.dart';
import '../utils/routes/routes_name.dart';
import '../utils/utils.dart';

class SignUpController extends GetxController {
  // XFile? image;
  RxString imagePath = "".obs;
  RxBool isLogInSeen = true.obs;
  RxBool isSignUPSeen = true.obs;
  File? fileImage;
  // XFile? img;
  RxBool isLoad = false.obs;
  RxBool isLogin = false.obs;
  File? compressedImg;

  bool get loading => isLoad.value;

  bool get login => isLogin.value;
  final _firebaseStorage = FirebaseStorage.instance;

  //firebase auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //show password for login
  void isLoginShow() {
    isLogInSeen.value = !isLogInSeen.value;
    update();
  }

  //show password for sign up
  void isSignUpShow() {
    isSignUPSeen.value = !isSignUPSeen.value;
    update();
  }

  ///image pick from gallery
  Future pickImageGall() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    final bytes = await img!.readAsBytes();
    final kb = bytes.length / 1024;
    final mb = kb / 1024;
    // setSendImg(true);
    if (kDebugMode) {
      print('original image size:$mb');
    }

    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp.jpg';

    // converting original image to compress it
    final result = await FlutterImageCompress.compressAndGetFile(
      img.path,
      targetPath,
      minHeight: 1080, //you can play with this to reduce siz
      minWidth: 1080,
      quality: 90, // keep this high to get the original quality of image
    );

    final data = await result!.readAsBytes();
    final newKb = data.length / 1024;
    final newMb = newKb / 1024;

    if (kDebugMode) {
      print('compress image size:$newMb');
    }

    compressedImg = File(result.path);
    imagePath.value = compressedImg!.path.toString();
    if (kDebugMode) {
      print(imagePath.toString());
    }
  }

  ///image pick from camera
  Future pickImageCam() async {
    final img = await ImagePicker().pickImage(source: ImageSource.camera);
    final bytes = await img!.readAsBytes();
    final kb = bytes.length / 1024;
    final mb = kb / 1024;
    // setSendImg(true);
    if (kDebugMode) {
      print('original image size:$mb');
    }

    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp.jpg';
    final result = await FlutterImageCompress.compressAndGetFile(
      img.path,
      targetPath,
      minHeight: 1080, //you can play with this to reduce siz
      minWidth: 1080,
      quality: 90, // keep this high to get the original quality of image
    );

    final data = await result!.readAsBytes();
    final newKb = data.length / 1024;
    final newMb = newKb / 1024;

    if (kDebugMode) {
      print('compress image size:$newMb');
    }

    compressedImg = File(result.path);
    imagePath.value = compressedImg!.path.toString();
    if (kDebugMode) {
      print(imagePath.toString());
    }
  }

  ///sign up user from firebase
  ///load button for sign up
  setLoading(bool value) {
    isLoad.value = value;
    update();
  }

  ///load button for login
  setLogInLoad(bool value) {
    isLogin.value = value;
    update();
  }

  ///create user with email and password
  Future setUser(
      {required String email,
      required String password,
      required BuildContext context,
      required String name,
      required String chatId}) async {
    try {
      setLoading(true);
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // Navigator.pushNamedAndRemoveUntil(
      //     context, RouteName.home, (route) => false);

      ///set profile storage
      UploadTask uploadTask = profileImgRef.putFile(
          File(imagePath.value.toString()),
          SettableMetadata(
            contentType: "image/jpeg",
          ));
      // await Future.value(uploadTask);
      TaskSnapshot snapshot = await uploadTask;
      String profileDown = await snapshot.ref.getDownloadURL();

      ///image profile url
      // var profileUrl = await profileImgRef.getDownloadURL();

      ///set user profile model
      UserModelContacts user = UserModelContacts(
          name: name,
          email: email,
          password: password,
          imageUrl: profileDown,
          userId: docId,
          about: "Hey there! I am using MaanApp.",
          chatId: chatId,
          isBlock: false,
          status: "online");

      ///upload to database
      await userDatabase.doc(docId).set(user.toMap());
      Navigator.pushNamedAndRemoveUntil(
          context, RouteName.home, (route) => false);
      await setLoading(false);
    } on FirebaseException catch (e) {
      setLoading(false);
      AppUtils.showFlushBar(context, e.message.toString());
      // print(e.message.toString());
    }
  }

  ///sign in user with email and password
  Future<void> signInUser(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      setLogInLoad(true);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      setStatus("online", _auth.currentUser!.uid);
      Navigator.pushNamedAndRemoveUntil(
          context, RouteName.home, (route) => false);
      setLogInLoad(false);
    } on FirebaseException catch (e) {
      setLogInLoad(false);
      AppUtils.showFlushBar(context, e.message.toString());
      // print(e.message.toString());
    }
  }

  void setStatus(String status, String uid) {
    FirebaseFirestore.instance
        .collection("usersProfile")
        .doc(uid)
        .update({"status": status});
  }
}
//Stream<QuerySnapshot> userSnapshot =
//     FirebaseFirestore.instance.collection('users').snapshots();
//
// userSnapshot.listen((snapshot) {
//   List<User> users = snapshot.docs
//       .map((doc) => User.fromFirestore(doc))
//       .toList();
//
//   // Do something with the retrieved users
// });
