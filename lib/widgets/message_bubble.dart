// import 'package:flutter/material.dart';
// import '../models/message.dart';
// import '../utils/date_utils.dart';
//
// class MessageBubble extends StatelessWidget {
//   final Message message;
//   final bool showReplyPreview;
//
//   const MessageBubble({
//     super.key,
//     required this.message,
//     this.showReplyPreview = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         left: message.isMe ? 60 : 16,
//         right: message.isMe ? 16 : 60,
//         top: 2,
//         bottom: 2,
//       ),
//       child: Column(
//         crossAxisAlignment: message.isMe
//             ? CrossAxisAlignment.end
//             : CrossAxisAlignment.start,
//         children: [
//           if (showReplyPreview && message.replyTo != null)
//             ReplyPreview(message: message),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               decoration: BoxDecoration(
//                 color: message.isMe
//                     ? const Color(
//                         0xFFDCF8C6,
//                       ) // iOS WhatsApp green for sent messages
//                     : Colors.white, // White for received messages
//                 borderRadius: BorderRadius.only(
//                   topLeft: const Radius.circular(18),
//                   topRight: const Radius.circular(18),
//                   bottomLeft: Radius.circular(message.isMe ? 18 : 4),
//                   bottomRight: Radius.circular(message.isMe ? 4 : 18),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withValues(alpha: 0.08),
//                     blurRadius: 2,
//                     offset: const Offset(0, 1),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     message.text,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: Color(0xFF0C1317),
//                       height: 1.3,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         ChatDateUtils.formatMessageTime(message.timestamp),
//                         style: const TextStyle(
//                           fontSize: 11,
//                           color: Color(0xFF667781),
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                       if (message.isMe) ...[
//                         const SizedBox(width: 4),
//                         Icon(
//                           Icons.done_all,
//                           size: 14,
//                           color: const Color(0xFF53BDEB), // Blue checkmarks
//                         ),
//                       ],
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
//
// class ReplyPreview extends StatelessWidget {
//   const ReplyPreview({super.key, required this.message});
//
//   final Message message;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(
//         left: message.isMe ? 0 : 0,
//         right: message.isMe ? 0 : 0,
//         bottom: 4,
//       ),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.grey.withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(8),
//         border: Border(
//           left: BorderSide(color: const Color(0xFF25D366), width: 3),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             message.replyTo!.isMe ? 'You' : 'Alex Smith',
//             style: const TextStyle(
//               fontSize: 12,
//               color: Color(0xFF25D366),
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             message.replyTo!.text,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey.withValues(alpha: 0.8),
//               fontWeight: FontWeight.w400,
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
// }
