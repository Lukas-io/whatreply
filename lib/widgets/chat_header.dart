import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatHeader extends StatelessWidget implements PreferredSizeWidget {


  const ChatHeader({
    super.key,

  });

  @override
  Widget build(BuildContext context) {
    return  AppBar(
      foregroundColor: Color(0XFFF8FEF8),
      backgroundColor: Color(0XFFF8FEF8),
      surfaceTintColor: Color(0XFFF8FEF8),

      elevation: 0,
      leading:  IconButton(
        onPressed: null,
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black87,
          size: 20,
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: 32,
          minHeight: 32,
        ),
      ),
      title: Row(

        children: [
          // Profile Image (Simplified)
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(108),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(108),
              child: Image.network(
                'https://static.vecteezy.com/system/resources/thumbnails/036/280/650/small_2x/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-illustration-vector.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.withValues(alpha: 0.3),
                    child: const Icon(
                      Icons.person,
                      color: Colors.black87,
                      size: 20,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Contact Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Jance",
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.4,
                      height: 0
                  ),
                ),
                Text(
                  "online",
                  style: TextStyle(
                    color: Colors.grey.withValues(alpha: 0.9),
                    fontSize: 11,
                    height: 0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],),
      actions: [

        // Video call button
        IconButton(
          onPressed: null,
          icon: const Icon(
            CupertinoIcons.videocam,
            color: Colors.black87,
            size: 30,
          ),
          padding: const EdgeInsets.all(0),
        ),


        // Voice call button
        IconButton(
          onPressed: null,
          icon:  Icon(
            CupertinoIcons.phone,
            color: Colors.black87,
            size: 24,
          ),
          padding: const EdgeInsets.all(0),
        ),
        SizedBox(width: 12,)
      ],
    );
  }

  @override

  Size get preferredSize =>Size(double.infinity, 40);
}
