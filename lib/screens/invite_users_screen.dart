import 'package:chatcy/res/colors.dart';
import 'package:chatcy/widgets/check_call_widget.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/utils.dart';

class InviteUsersScreen extends StatefulWidget {
  const InviteUsersScreen({super.key});

  @override
  State<InviteUsersScreen> createState() => _InviteUsersScreenState();
}

class _InviteUsersScreenState extends State<InviteUsersScreen> {
  ScrollController controller = ScrollController();
  TextEditingController searchCon = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    // getContactAll();
    getContact();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors.whiteColor),
          title: isHide
              ? const SizedBox()
              : Text(
                  "Invite Users",
                  style: TextStyle(color: AppColors.whiteColor, fontSize: 18),
                ),
          actions: [
            isHide
                ? showField()
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        isHide = !isHide;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Icon(
                        Icons.search,
                        color: AppColors.whiteColor,
                        size: 26,
                      ),
                    ),
                  )
          ],
        ),
        body: fetchContactsList.isEmpty
            ? ListView.builder(
                itemCount: 12,
                itemBuilder: (context, int index) {
                  return AppUtils.showShimmer();
                },
              )
            : searchList.isEmpty
                ? ListView.separated(
                    controller: controller,
                    itemCount: fetchContactsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Contact contact = fetchContactsList[index];
                      Color color = colors[index % colors.length];
                      return AppUtils.showMobileContactUtils(
                          // phoneNum: '',
                          onInvite: () async {
                            await launch(
                                "sms:${contact.phones[0].number.toString().substring(1)}?body=Let's chat on MaanApp! It's a fast, simple, and secure app we can use to message and Bob call each other for free.");
                          },
                          name: contact.displayName.toString().substring(0, 1),
                          contactDisplayName: contact.displayName,
                          phoneNum: contact.phones.isEmpty
                              ? ""
                              : contact.phones[0].number,
                          profileColor: color.withOpacity(0.75));
                    },
                    separatorBuilder: (context, int index) {
                      return Divider(
                        indent: 80,
                        height: 0.0,
                        thickness: 0.4,
                        color: AppColors.defaultColor.withOpacity(0.2),
                      );
                    },
                  )
                : ListView.separated(
                    controller: controller,
                    itemCount: searchList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Contact contact = searchList[index];
                      Color color = colors[index % colors.length];
                      return AppUtils.showMobileContactUtils(
                          // phoneNum: '',
                          onInvite: () async {
                            await launch(
                                "sms:${contact.phones[0].number.toString().substring(1)}?body=Let's chat on MaanApp! It's a fast, simple, and secure app we can use to message and Bob call each other for free.");
                          },
                          name: contact.displayName.toString().substring(0, 1),
                          contactDisplayName: contact.displayName,
                          phoneNum: contact.phones.isEmpty
                              ? ""
                              : contact.phones[0].number,
                          profileColor: color.withOpacity(0.75));
                    },
                    separatorBuilder: (context, int index) {
                      return Divider(
                        indent: 80,
                        height: 0.0,
                        thickness: 0.4,
                        color: AppColors.defaultColor.withOpacity(0.2),
                      );
                    },
                  ),
      ),
    );
  }

  ///get users contact list and and get user permission
  List<Contact> fetchContactsList = [];

  Future<List<Contact>> getContact() async {
    bool isGranted = await Permission.contacts.status.isGranted;
    if (!isGranted) {
      isGranted = await Permission.contacts.request().isGranted;
    }
    if (isGranted) {
      List<Contact> list = await FastContacts.getAllContacts();
      fetchContactsList = list;
      // return await FastContacts.getAllContacts();
    }
    setState(() {});
    return fetchContactsList;
  }

  final List<Color> colors = [
    Colors.red,
    Colors.green,
    AppColors.orangeColor,
    AppColors.buttonColor,
    Colors.purple,
    AppColors.defaultColor,
    Colors.lightBlueAccent,
    AppColors.blueColor,
    Colors.deepOrange,
    AppColors.darkGreen,
  ];
  bool isHide = false;
  List<Contact> searchList = [];
  Widget showField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      width: Get.width / 1.3,
      child: TextFormField(
        controller: searchCon,
        onChanged: (val) {
          // Update the contacts list based on the search query

          if (val.isNotEmpty) {
            setState(() {
              searchList = filterContacts(val);
              // getContact();
            });
          } else {
            getContact();
          }
        },
        style: TextStyle(color: AppColors.whiteColor),
        onFieldSubmitted: (val) {
          getContact();
          isHide = false;
          searchCon.clear();
        },
        autofocus: true,
        cursorColor: AppColors.whiteColor,
        decoration: InputDecoration(
          hintText: 'Search....',
          hintStyle: TextStyle(color: AppColors.whiteColor),
          suffixIcon: GestureDetector(
            onTap: () => setState(() {
              getContact();
              isHide = false;
              searchCon.clear();
              searchList = [];
              setState(() {});
              // onSearchTextChanged('');
            }),
            child: const Icon(
              Icons.clear,
              color: Colors.white,
            ),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  List<Contact> filterContacts(String query) {
    // Filter the contacts based on the search query
    return fetchContactsList.where((contact) {
      return contact.displayName
              .toLowerCase()
              .trim()
              .contains(query.toLowerCase().trim()) ??
          false;
    }).toList();
  }
}
