import 'dart:io';

import 'package:chatcy/controllers/services/firebase_helper_method.dart';
import 'package:chatcy/main.dart';
import 'package:chatcy/model/message_model.dart';
import 'package:chatcy/model/story_make_model.dart';
import 'package:chatcy/model/user_data_model.dart';
import 'package:chatcy/res/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:story_maker/story_maker.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

const int appId = 1485574049;
const String signInId =
    '214e9a76dc43413cad47fbbc0a4632e0173dfc90eba773125e81cd5241295fd5';

class ChatViewProvider extends ChangeNotifier {
  List onTapList = [];
  List messagesIdLi = [];
  List namesList = [];
  List idsList = [];
  int countMsg = 0;
  File? statusImage;
  bool isStatusUploading = false;
  File? compressedImg;
  // bool isSaving = false;
  // ScreenshotController screenshotController = ScreenshotController();
  void checkStatusUpload(bool isUploaded) {
    isStatusUploading = isUploaded;
    notifyListeners();
  }

  ///get call history id
  String? callHistoryDocId;

  ///getting user info
  UserDataModel? userInfo;
  bool isSaving = false;
  void isSavebBool(bool isSave) {
    isSaving = isSave;
    notifyListeners();
  }

  void increMsgCount(int countMsgAl) {
    countMsg++;
    countMsg = countMsgAl;
    notifyListeners();
  }

  void setModelTonul() {
    userInfo = null;
    notifyListeners();
  }

  ///method for delete messages and select messages
  void checkItemExixt(MessageModel messageModel) {
    bool isTextEmpty = messageModel.text == null || messageModel.text!.isEmpty;
    bool isImageEmpty =
        messageModel.image == null || messageModel.image!.isEmpty;
    bool isVoiceNote = messageModel.voice != null;

    if (messagesIdLi.contains(messageModel.messageId)) {
      onTapList.remove(
        isTextEmpty
            ? (isImageEmpty
                ? (isVoiceNote ? messageModel.voice : messageModel.text!)
                : messageModel.image!)
            : messageModel.text,
      );
      messagesIdLi.remove(messageModel.messageId);
    } else {
      String itemToAdd = isTextEmpty
          ? (isImageEmpty
              ? (isVoiceNote
                  ? messageModel.voice.toString()
                  : messageModel.text!)
              : messageModel.image!)
          : messageModel.text!;
      onTapList.add(itemToAdd);
      messagesIdLi.add(messageModel.messageId);
    }
    notifyListeners();
  }

  void checkLi() {
    onTapList = [];
    namesList = [];
    idsList = [];
    messagesIdLi = [];
    notifyListeners();
  }

  void deleteSingleItem(MessageModel messageModel) {
    onTapList.remove(messageModel.text);
    messagesIdLi.remove(messageModel.messageId);
    notifyListeners();
  }

  ///void delete selected messages
  Future<void> deleteMessages(
      {required String docIdChatRoom, required String messageId}) async {
    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(docIdChatRoom)
        .collection("messages")
        .doc(messageId)
        .delete();
    messagesIdLi = [];
    onTapList = [];
    notifyListeners();
  }

  ///method for forard messages
  void selectName(String name, String ids) {
    if (idsList.contains(ids)) {
      namesList.remove(name);
      idsList.remove(ids);
    } else {
      namesList.add(name);
      idsList.add(ids);
    }
    notifyListeners();
  }

  ///get my profile info
  var uid = FirebaseAuth.instance.currentUser!.uid;

  Future<UserDataModel> myInfo() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("usersProfile")
        .doc(uid)
        .get();
    if (snapshot.data() != null) {
      userInfo = UserDataModel.fromMap(snapshot.data() as Map<String, dynamic>);
    }
    notifyListeners();
    return userInfo!;
  }

  String photoURL = '';
  String cuUserName = '';
  Future<void> getUserInfoPlus() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("usersProfile")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (snapshot.data() != null) {
      photoURL = snapshot.get('profileUrl');
      cuUserName = snapshot.get('name');
    }
    notifyListeners();
  }

  Future callHisoryId() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("callHistory")
        .where('users', arrayContains: uid)
        // .orderBy("callTime")
        .get();
    if (snapshot.docs.isNotEmpty) {
      callHistoryDocId = snapshot.docs.first.get('CallHistoryId');
    }
    notifyListeners();
  }

  ///check internet connection
  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  int? countChk;
  Future getDocIdChR(String id) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatRooms")
        .where('chatroomid', isEqualTo: id)
        .get();
    if (snapshot.docs.isNotEmpty) {
      countChk = snapshot.docs.first.get('fromMessageCount');
    }
    notifyListeners();
  }

  ///save image into gallery

  Future<void> saveToGallery(
      BuildContext context, ScreenshotController con) async {
    isSavebBool(true);
    notifyListeners();
    con.capture(pixelRatio: 3.0).then((Uint8List? image) async {
      saveImage(image!);
      isSavebBool(false);
      notifyListeners();
      // if (!mounted) return;
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          barrierDismissible: false,
          title: 'Success!',
          text: 'Image Saved Successfully');
    }).catchError((err) {
      isSavebBool(false);
      notifyListeners();
      if (kDebugMode) {
        print(err);
      }
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          barrierDismissible: false,
          title: 'Error!',
          text: 'Unable to save image');
    });
  }

  void saveImage(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = "screenshot_$time";
    await requestPermission(Permission.storage);
    await ImageGallerySaver.saveImage(bytes, name: name, quality: 100);
  }

  ///share image to other Apps
  bool isShareImg = false;
  void isShareSet(bool isShareSet) {
    isShareImg = isShareSet;
    notifyListeners();
  }

  void shareImage(ScreenshotController con) async {
    isShareSet(true);
    await con.capture(pixelRatio: 3.0).then((Uint8List? image) async {
      final Directory temp = await getTemporaryDirectory();
      File imageFile = File('${temp.path}/image.jpg');
      await imageFile.writeAsBytes(image!);
      isShareSet(false);
      Share.shareXFiles(
        [XFile('${temp.path}/image.jpg')],
        text: 'Check This Out',
      );
    });
    notifyListeners();
  }

  ///check data if load or no not

  final int batchSize = 10; // Number of items to load per batch
  List<DocumentSnapshot> documents = [];
  bool isLoading = false;
  bool hasMore = true;

  void checkBool(bool isLoaded) {
    isLoading = isLoaded;
    notifyListeners();
  }

  late ScrollController _scrollController;
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // When user reaches the end of the list
      if (!isLoading && hasMore) {
        loadData();
      }
    }
  }

  ///load data if not load more
  Future<void> loadData() async {
    if (!isLoading && hasMore) {
      checkBool(false);

      QuerySnapshot querySnapshot;
      if (documents.isEmpty) {
        // Initial load
        querySnapshot = await FirebaseFirestore.instance
            .collection('callHistory')
            .doc(callHistoryDocId)
            .collection("calls")
            .orderBy('dateTime',
                descending: true) // Adjust orderBy as per your needs
            .limit(batchSize)
            .get();
      } else {
        // Load more
        querySnapshot = await FirebaseFirestore.instance
            .collection('callHistory')
            .doc(callHistoryDocId)
            .collection("calls")
            .orderBy('dateTime',
                descending: true) // Adjust orderBy as per your needs
            .startAfterDocument(documents.last)
            .limit(batchSize)
            .get();
      }

      // setState(() {
      if (querySnapshot.docs.length < batchSize) {
        // If fetched documents are less than batch size, no more data
        hasMore = false;
      }
      documents.addAll(querySnapshot.docs);
      isLoading = false;
      notifyListeners();
    }
  }

  ///selected and edit image for status
  Future<void> statusImg(BuildContext context) async {
    await [
      Permission.photos,
      Permission.storage,
    ].request();
    final image = ImagePicker();
    image.pickImage(source: ImageSource.gallery).then((file) async {
      if (file != null) {
        final File? editedFile = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => StoryMaker(
              filePath: file.path,
              doneButtonChild: GestureDetector(
                // onTap: onStatusUpload,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Add to status",
                        style: TextStyle(color: AppColors.defaultColor),
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      Icon(Icons.arrow_forward_ios,
                          size: 12.0, color: AppColors.defaultColor)
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        if (editedFile != null) {
          ///folder ref
          final bytes = await editedFile.readAsBytes();
          final kb = bytes.length / 1024;
          final mb = kb / 1024;
          if (kDebugMode) {
            print('original image size:$mb');
          }

          final dir = await path_provider.getTemporaryDirectory();
          final targetPath = '${dir.absolute.path}/temp.jpg';

          // converting original image to compress it
          final result = await FlutterImageCompress.compressAndGetFile(
            editedFile.path,
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
          var imgPath = compressedImg!.path.toString();
          if (kDebugMode) {
            print('compressed image path');
            print(imgPath);
            print('compressed image path');
          }
          firebase_storage.Reference chatImages = firebase_storage
              .FirebaseStorage.instance
              .ref()
              .child("status/${DateTime.now().toIso8601String()}");
          UploadTask uploadTask = chatImages.putFile(
              File(imgPath),
              SettableMetadata(
                contentType: "image/jpeg",
              ));
          TaskSnapshot snapshot = await uploadTask;
          var statusLink = await snapshot.ref.getDownloadURL();
          await checkStories(statusLink);

          // statusImage = editedFile;
          // if (kDebugMode) {
          //   print('image path');
          //   print(statusImage);
          // }
        } else {
          flutterToast(message: "no status image selected.");
        }
      }
    });
    notifyListeners();
  }

  // Future<void> uploadStory(String image) async {
  //   var docId = FirebaseHelper.getRandomString(8);
  //   StoryMakeModel storyMake = StoryMakeModel(
  //       name: userInfo!.name,
  //       profileUrl: userInfo!.imageUrl,
  //       storyImage: [image],
  //       docId: docId,
  //       uploadTime: DateTime.now(),
  //       uid: {FirebaseAuth.instance.currentUser!.uid.toString(): true});
  //   FirebaseFirestore.instance
  //       .collection('story')
  //       .doc(docId)
  //       .set(storyMake.toMap(),);
  // "name":FieldValue.arrayUnion(['sd'])
  // "name":FieldValue.arrayUnion(['sd'])
  // }

  Future<StoryMakeModel> checkStories(String image) async {
    StoryMakeModel? storyModel;
    var docId = FirebaseHelper.getRandomString(8);
    QuerySnapshot storySnapshot = await FirebaseFirestore.instance
        .collection("story")
        .where("uid.${FirebaseAuth.instance.currentUser!.uid}", isEqualTo: true)
        .get();

    if (storySnapshot.docs.length > 0) {
      var docData = storySnapshot.docs[0].data();
      StoryMakeModel storyMakeModel =
          StoryMakeModel.fromJson(docData as Map<String, dynamic>);
      storyMakeModel.storyImage!.add(image);
      storyMakeModel.currentUserUid = userInfo!.userId!;
      storyMakeModel.name = cuUserName;
      storyMakeModel.profileUrl = photoURL!;
      // Update the document in Firestore with the new data
      await FirebaseFirestore.instance
          .collection('story')
          .doc(storySnapshot.docs[0].id)
          .set(storyMakeModel.toMap(), SetOptions(merge: true));
      storyModel = storyMakeModel;
    } else {
      StoryMakeModel storyMake = StoryMakeModel(
          name: cuUserName,
          profileUrl: photoURL,
          storyImage: [image],
          docId: docId,
          uploadTime: DateTime.now(),
          uid: {FirebaseAuth.instance.currentUser!.uid.toString(): true},
          currentUserUid: FirebaseAuth.instance.currentUser!.uid);
      FirebaseFirestore.instance
          .collection('story')
          .doc(docId)
          .set(storyMake.toMap(), SetOptions(merge: true));
      storyModel = storyMake;
    }
    return storyModel;
  }

  ///try to delete the story after 24 hours
  // Future<void> deleteOldStories() async {
  //   try {
  //     // Get the current user's UID
  //     String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  //
  //     // Calculate the timestamp for 24 hours ago
  //     DateTime twentyFourHoursAgo =
  //         DateTime.now().subtract(const Duration(hours: 24));
  //
  //     // Query Firestore to fetch stories for the current user
  //     QuerySnapshot storySnapshot = await FirebaseFirestore.instance
  //         .collection("story")
  //         .where("uid.$currentUserUid", isEqualTo: true)
  //         .get();
  //
  //     // Check if the story document is not empty
  //     if (storySnapshot.docs.isNotEmpty) {
  //       // Iterate through the documents and delete stories older than 24 hours
  //       for (DocumentSnapshot document in storySnapshot.docs) {
  //         Map<String, dynamic> data = document.data() as Map<String, dynamic>;
  //         DateTime uploadTime = (data['uploadTime'] as Timestamp).toDate();
  //
  //         // Check if the upload time is older than 24 hours
  //         if (uploadTime.isBefore(twentyFourHoursAgo)) {
  //           // Delete the story if it's older than 24 hours
  //           await FirebaseFirestore.instance
  //               .collection("story")
  //               .doc(document.id)
  //               .delete();
  //           print('Story deleted: ${document.id}');
  //         }
  //       }
  //     } else {
  //       print('No stories found for the current user.');
  //     }
  //   } catch (e) {
  //     print('Error deleting old stories: $e');
  //     // Handle the error
  //   }
  // }
}
