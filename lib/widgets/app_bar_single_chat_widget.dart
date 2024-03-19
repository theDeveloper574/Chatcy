// import 'package:chatcy/controllers/provider/chat_view_provider.dart';
// import 'package:chatcy/main.dart';
// import 'package:chatcy/screens/contacts_view.dart';
// import 'package:chatcy/utils/routes/routes_name.dart';
// import 'package:chatcy/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// import '../res/colors.dart';

// class AppBarSingleChatWidget extends StatelessWidget {
//   final String urlImage;
//   final String name;
//   final String status;
//   final String roomId;
//   const AppBarSingleChatWidget(
//       {super.key,
//       required this.urlImage,
//       required this.name,
//       required this.status,
//       required this.roomId});

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       toolbarHeight: 60,
//       elevation: 0.0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       automaticallyImplyLeading: false,
//       backgroundColor: AppColors.sliderOneColor,
//       title: Consumer<ChatViewProvider>(
//         builder: (context, valueLis, child) {
//           return Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               AppUtils.sizedBox(0.0, 4),
//               GestureDetector(
//                 onTap: () {
//                   if (valueLis.onTapList.isEmpty) {
//                     Navigator.pop(context);
//                   } else {
//                     valueLis.onTapList = [];
//                   }
//                 },
//                 // onTap: () => Navigator.pop(context),
//                 child: const Icon(
//                   Icons.arrow_back,
//                   color: Colors.black,
//                 ),
//               ),
//               AppUtils.sizedBox(0.0, 8),
//               valueLis.onTapList.isNotEmpty
//                   ? const SizedBox()
//                   : CircleAvatar(
//                       radius: 22,
//                       child: Hero(
//                         tag: 'chat-list-profile',
//                         child: CircleAvatar(
//                           radius: 24,
//                           backgroundImage: NetworkImage(urlImage),
//                           // backgroundImage: AssetImage('asset/signup.png'),
//                         ),
//                       ),
//                     ),
//               AppUtils.sizedBox(0.0, 10),
//               valueLis.onTapList.isNotEmpty
//                   ? Text(valueLis.onTapList.length.toString())
//                   : Expanded(
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.of(context, rootNavigator: true)
//                               .pushNamed(RouteName.userProfileView);
//                         },
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ///username
//                             Text(
//                               name,
//                               style: GoogleFonts.roboto(
//                                 textStyle: const TextStyle(
//                                     color: Colors.black, fontSize: 14),
//                               ),
//                             ),
//                             AppUtils.sizedBox(5.0, 0.0),
//                             Text(
//                               status,
//                               style: const TextStyle(
//                                 color: Colors.black87,
//                                 fontSize: 10,
//                                 overflow: TextOverflow.clip,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//             ],
//           );
//         },
//       ),

//       ///show data for calls
//       actions: [
//         Consumer<ChatViewProvider>(
//           builder: (context, valueLi, child) {
//             return valueLi.onTapList.isEmpty
//                 ? AppUtils.showRowCall()
//                 : AppUtils.showForwodbutton(
//                     onDel: () {
//                       for (var i in valueLi.onTapList) {
//                         valueLi.deleteMessages(
//                             docIdChatRoom: roomId, messageId: i.toString());
//                       }
//                       flutterToast(message: "messages deleted.");
//                     },
//                     onForward: () {
//                       valueLi.idsList = [];
//                       valueLi.namesList = [];
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => const ContactView(
//                             isForward: true,
//                           ),
//                         ),
//                       );
//                     },
//                   );
//           },
//         )
//       ],
//     );
//   }
// }
