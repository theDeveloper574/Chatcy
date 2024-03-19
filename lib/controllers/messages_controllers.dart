import 'dart:io';

import 'package:chatcy/controllers/sign_up_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../widgets/show_profile_img_wid.dart';

class MessageControllers extends GetxController {
  SignUpController imageCon = SignUpController();
  RxBool isImgSend = false.obs;
  RxDouble? imageUploadProgress;
  RxString profileUrl = "".obs;
  RxDouble progress = 0.0.obs;
  File? compressedImg;
  RxBool isEmojiChk = false.obs;

  // RxBool isSending = false.obs;
  RxBool isVoiceSend = false.obs;
  RxString imgPath = "".obs;
  RxString voiceURL = "".obs;

  // bool get _isSend => isSend.value;

  setSendImg(bool value) {
    isImgSend.value = value;
    update();
  }

  setSendVoice(bool value) {
    isVoiceSend.value = value;
    update();
  }

  //    UploadTask uploadTask = profileImgRef.putFile(File(imagePath.value));
  //       // await Future.value(uploadTask);
  //       TaskSnapshot snapshot = await uploadTask;
  //       var profileDown = await snapshot.ref.getDownloadURL();
  Future setVoiceMessage(String voice) async {
    setSendVoice(true);
    // voiceURL.value = voice;
    // Future.delayed(const Duration(seconds: 4)).then((value) {
    //   setSendVoice(false);
    // });
    update();
  }

  void sendImageMessage() {
    setSendImg(true);
    // Future.delayed(const Duration(seconds: 4), () {
    //   setSendImg(false);
    // });
  }

  //get image from gallery and upload it
  Future pickImageGall(
      {required BuildContext context,
      required void Function()? onSendMethod,
      required TextEditingController controller}) async {
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
    imgPath.value = compressedImg!.path.toString();
    if (kDebugMode) {
      print('compressed image path');
      print(imgPath.value.toString());
      print('compressed image path');
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImageBeforeSend(
          controller: controller,
          imageSendCall: onSendMethod,
          image: File(img.path.toString()),
        ),
      ),
    );
    // setSendImg(true);
    // UploadTask uploadTask = chatImages.putFile(File(img.path.toString()));
    // await Future.value(uploadTask);
    // profileUrl.value = await chatImages.getDownloadURL();
    // setSendImg(false);
    update();
  }

  void setEmoji() {
    if (isEmojiChk.value) {
      isEmojiChk.value = !isEmojiChk.value;
      update();
    }
  }

  void openTap() {
    isEmojiChk.value = !isEmojiChk.value;
    update();
  }
}
