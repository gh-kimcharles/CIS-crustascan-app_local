import 'package:crustascan_app/providers/auth_provider.dart';
import 'package:crustascan_app/providers/guest_provider.dart';
import 'package:crustascan_app/utils/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crustascan_app/providers/user_provider.dart';
import 'package:crustascan_app/views/pages/profile/profile_page.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final guestProvider = Provider.of<GuestProvider>(context);

    final user = userProvider.user;
    final guest = guestProvider.guest;

    return Container(
      padding: EdgeInsets.all(18),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            child: Hero(
              tag: 'profile-picture',
              child: CircleAvatar(
                radius: 24,
                backgroundImage: ImageHelper.getImageProvider(user.imagePath),
                key: ValueKey(user.imagePath),
              ),
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome back,",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              if (authProvider.isGuest)
                Text(
                  "${guest?.firstName}! ${guest?.lastName}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              else if (authProvider.isUser)
                Text(
                  "${user.firstName} ${user.lastName}!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
