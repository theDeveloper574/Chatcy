// import 'package:flutter/material.dart';
// import 'package:progressive_image/progressive_image.dart';
//
// import '../utils/utils.dart';
//
// class ShowImageContainerWid extends StatelessWidget {
//   final Color color;
//   final Function() imageTap;
//   final String imageHol;
//   final String sendTime;
//
//   const ShowImageContainerWid(
//       {super.key,
//       required this.color,
//       required this.imageTap,
//       required this.imageHol,
//       required this.sendTime});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(10.0),
//           child: GestureDetector(
//             onTap: imageTap,
//             child: Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: color, width: 2.8),
//               ),
//               child: ProgressiveImage(
//                 fit: BoxFit.cover,
//                 fadeDuration: const Duration(seconds: 5),
//                 placeholder: const AssetImage('asset/image_load.gif'),
//                 thumbnail: NetworkImage(imageHol),
//                 image: NetworkImage(imageHol),
//                 width: 200,
//                 height: 300,
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: 0,
//           right: 0,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   sendTime,
//                   style: const TextStyle(color: Colors.grey, fontSize: 12),
//                 ),
//                 AppUtils.sizedBox(0.0, 4.0),
//                 const Icon(
//                   Icons.done_all_sharp,
//                   color: Colors.blue,
//                   size: 18,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
