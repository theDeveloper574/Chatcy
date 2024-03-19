// import 'package:bindhuo/Messaging/Groups/call_work/pickup_screen.dart';
import 'package:chatcy/controllers/provider/chat_view_provider.dart';
import 'package:chatcy/model/call_model.dart';
import 'package:chatcy/widgets/show_pick_up_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  // final CallMethods callMethods = CallMethods();
  // final ChatRoomModel? chatRoom;

  PickupLayout({
    required this.scaffold,
    // this.chatRoom,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('call')
            .doc(context.watch<ChatViewProvider>().uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data!.data() != null) {
            // Data is available
            Call call = Call.fromJson(snapshot.data!.data()!);
            return PickupScreen(call: call);
            // }
          } else if (snapshot.hasError) {
            // return const CircularProgressIndicator();
            // print("Data is not Available");
            // return scaffold;
            // Loading state
            return const Center(child: CircularProgressIndicator());
          }
          // return Container(height: 100,width: 200,color: Colors.green,);
          return scaffold;
        });
    // : const Scaffold(
    //     body: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    // );
  }
}
