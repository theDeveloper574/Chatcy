import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatcy/controllers/provider/chat_view_provider.dart';
import 'package:chatcy/widgets/check_call_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/get_method_controllers.dart';
import '../controllers/services/database_collection.dart';
import '../controllers/sign_up_controller.dart';
import '../main.dart';
import '../model/user_data_model.dart';
import '../res/colors.dart';
import '../utils/utils.dart';
import '../widgets/call_info_detail_wid.dart';
import '../widgets/circle_image_widget.dart';
import '../widgets/show_profile_img_wid.dart';

class MyProfileView extends StatefulWidget {
  const MyProfileView({super.key});

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  GetMethodController pathVal = GetMethodController();
  SignUpController pathCon = SignUpController();

  // TextEditingController nameEdit = TextEditingController();

  @override
  void initState() {
    pathVal.getCurrentUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors.whiteColor),
          title: Text(
            "Profile",
            style: TextStyle(color: AppColors.whiteColor, fontSize: 20),
          ),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Obx(() {
              return StreamBuilder<DocumentSnapshot>(
                stream: pathVal.userDataSnapshot(pathVal.uid.value),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.data == null || snapshot.data!.data() == null) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 300.0),
                      child: Text(
                        'loading...',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // return AppUtils.sizedBox(0.0, 0.0);
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else if (snapshot.hasData) {
                    UserDataModel user = UserDataModel.fromMap(
                        snapshot.data!.data() as Map<String, dynamic>);
                    return Center(
                      child: Column(
                        children: [
                          AppUtilsChats.sizedBox(70.0, 0.0),
                          Hero(
                            tag: "show-profile-picture",
                            child: CircleImageWidget(
                              onProfileChangeTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ShowProfileImgWid(
                                      image: user.imageUrl!,
                                    ),
                                  ),
                                );
                              },
                              onImageChangeTap: () {
                                Get.defaultDialog(
                                    backgroundColor: AppColors.whiteColor,
                                    buttonColor: AppColors.defaultColor,
                                    title: 'Get Image From',
                                    middleText: 'Camera OR Gallery',
                                    textConfirm: 'Gallery',
                                    confirmTextColor: Colors.white,
                                    textCancel: 'Camera',
                                    cancelTextColor: AppColors.defaultColor,
                                    onCancel: () async {
                                      // print('pick image from camera');
                                      // Navigator.pop(context);
                                      await pathCon.pickImageCam();

                                      ///set profile storage
                                      UploadTask uploadTask =
                                          changeProfileImgRef.putFile(
                                              File(pathCon.imagePath.value),
                                              SettableMetadata(
                                                contentType: "image/jpeg",
                                              ));
                                      await Future.value(uploadTask);
                                      var profileUrl = await changeProfileImgRef
                                          .getDownloadURL();
                                      context
                                          .read<ChatViewProvider>()
                                          .getUserInfoPlus();

                                      pathVal.updateCurrentData(
                                          userId: user.userId!,
                                          updateField: {
                                            "profileUrl": profileUrl
                                          });
                                    },
                                    onConfirm: () async {
                                      // print('pick image from gallery');
                                      Navigator.pop(context);
                                      await pathCon.pickImageGall();

                                      ///set profile storage
                                      UploadTask uploadTask =
                                          changeProfileImgRef.putFile(
                                              File(pathCon.imagePath.value));
                                      await Future.value(uploadTask);
                                      var profileUrl = await changeProfileImgRef
                                          .getDownloadURL();
                                      context
                                          .read<ChatViewProvider>()
                                          .getUserInfoPlus();
                                      pathVal.updateCurrentData(
                                          userId: user.userId!,
                                          updateField: {
                                            "profileUrl": profileUrl
                                          });
                                    });
                              },
                              imageProvider: user.imageUrl!.isEmpty
                                  ? const AssetImage('asset/loader_image.gif')
                                  : CachedNetworkImageProvider(user.imageUrl!)
                                      as ImageProvider,
                            ),
                          ),
                          AppUtilsChats.sizedBox(40.0, 0.0),
                          ProfileWidget(
                            imageProvider: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.0),
                              child: Icon(Icons.person),
                            ),
                            onListTap: () {
                              AppUtilsChats.setBottomSheet(
                                  maxLength: 15,
                                  context: context,
                                  addText: "Enter your name",
                                  initialVal: user.name!,
                                  onChanged: (val) {
                                    // print(val);
                                    pathVal.textFieldVal.value = val;
                                  },
                                  onSave: () {
                                    if (pathVal.textFieldVal.value.isEmpty) {
                                      flutterToast(
                                          message: "Name can't be empty");
                                    } else if (pathVal
                                            .textFieldVal.value.length <
                                        4) {
                                      flutterToast(
                                          message: "Name can't be less than 4");
                                    } else {
                                      // print(pathVal.textFieldVal.value);
                                      pathVal.updateCurrentData(
                                          userId: user.userId!,
                                          updateField: {
                                            "name": pathVal.textFieldVal.value
                                          });
                                      Navigator.pop(context);
                                    }
                                  });
                            },
                            nameTitle: "Name",
                            about: user.name == null ? '' : user.name!,
                            audioCallWid: Icon(
                              Icons.edit,
                              color: AppColors.defaultColor,
                              size: 22,
                            ),
                            videoCallWid: AppUtilsChats.sizedBox(0.0, 0.0),
                          ),
                          ProfileWidget(
                            imageProvider: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.0),
                              child: Icon(Icons.warning),
                            ),
                            onListTap: () {
                              AppUtilsChats.setBottomSheet(
                                  maxLength: 40,
                                  context: context,
                                  addText: "Add about",
                                  initialVal: user.about!,
                                  onChanged: (val) {
                                    pathVal.textFieldVal.value = val;
                                  },
                                  onSave: () {
                                    // print(pathVal.textFieldVal.value);
                                    pathVal.updateCurrentData(
                                        userId: user.userId!,
                                        updateField: {
                                          "about": pathVal.textFieldVal.value
                                        });
                                    Navigator.pop(context);
                                  });
                            },
                            nameTitle: "About",
                            about: user.about!,
                            audioCallWid: Icon(
                              Icons.edit,
                              color: AppColors.defaultColor,
                              size: 22,
                            ),
                            videoCallWid: AppUtilsChats.sizedBox(0.0, 0.0),
                          ),
                          ProfileWidget(
                            imageProvider: const Padding(
                              padding: EdgeInsets.only(top: 22.0),
                              child: Icon(Icons.phone),
                            ),
                            onListTap: () {},
                            nameTitle: "Phone",
                            about: "+92 304 5070559",
                            audioCallWid: AppUtilsChats.sizedBox(0.0, 0.0),
                            videoCallWid: AppUtilsChats.sizedBox(0.0, 0.0),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              );
            })
          ],
        ),
      ),
    );
  }
}
