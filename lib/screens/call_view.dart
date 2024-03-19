import 'package:chatcy/model/call_make_model.dart';
import 'package:chatcy/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/provider/chat_view_provider.dart';
import '../res/colors.dart';
import '../widgets/chat_list_wid.dart';
import 'call_info_view.dart';

class CallView extends StatefulWidget {
  const CallView({super.key});

  @override
  State<CallView> createState() => _CallViewState();
}

class _CallViewState extends State<CallView> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatViewProvider>(context, listen: false);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 1,
        (context, index) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("callHistory")
                  .doc(provider.callHistoryDocId)
                  .collection('calls')
                  .orderBy("dateTime", descending: true)
                  .snapshots(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return const Text(
                    'No CALL HISTORY FOUND.',
                    textAlign: TextAlign.center,
                  );
                }
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot callSnap = snapshot.data as QuerySnapshot;
                    List limitList = [];
                    limitList.addAll(callSnap.docs);
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: limitList.length,
                      itemBuilder: (context, int index) {
                        CallMakeModel callData = CallMakeModel.fromMap(
                            limitList[index].data() as Map<String, dynamic>);
                        return ChatListAndCallWidget(
                          textFontWei: FontWeight.normal,
                          textColor: AppColors.greyColor,
                          imageProfile: callData.recPic!,
                          iconWidget: callData.isMissed == true
                              ? const Icon(
                                  Icons.call_missed,
                                  color: Colors.red,
                                  size: 18,
                                )
                              : const Icon(
                                  Icons.call_received,
                                  color: Colors.green,
                                  size: 18,
                                ),
                          msgOrCallTime:
                              AppUtils.callHistoryTime(callData.dateTime!),
                          userName: callData.recName!,
                          onTap: () {
                            // Navigator.of(context, rootNavigator: true)
                            //     .pushNamed(RouteName.callInfoView);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CallInfoView(callData),
                              ),
                            );
                            // Navigator.pushNamed(context, RouteName.callInfoView);
                          },
                          widget: callData.callType == "audio"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Icon(
                                    Icons.call_outlined,
                                    color: AppColors.defaultColor,
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Icon(
                                    Icons.videocam_outlined,
                                    color: AppColors.defaultColor,
                                  ),
                                ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    const Center(
                      child: Text(
                          "An error occurred! Please Check Your Internet Connection."),
                    );
                  } else {
                    const Center(
                      child: Text("NO Call History Found"),
                    );
                  }
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 138.0),
                    child: Center(
                      child: Transform.scale(
                          scale: 0.7, child: const CircularProgressIndicator()),
                    ),
                  );
                }

                return const SizedBox();
              });
        },
      ),
    );
  }
}
