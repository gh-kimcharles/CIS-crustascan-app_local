import 'package:crustascan_app/providers/auth_provider.dart';
import 'package:crustascan_app/providers/guest_provider.dart';
import 'package:crustascan_app/providers/user_provider.dart';
import 'package:crustascan_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomBottomNavIsGuest extends StatelessWidget {
  final Widget navigatePage;
  final String textMessage;
  final String textAuth;
  const CustomBottomNavIsGuest({
    super.key,
    required this.navigatePage,
    required this.textMessage,
    required this.textAuth,
  });

  @override
  Widget build(BuildContext context) {
    Future<void> handleLogout(BuildContext context) async {
      await Provider.of<UserProvider>(
        context,
        listen: false,
      ).resetUser(context);

      await AuthService().clearAuthData();

      Provider.of<AuthProvider>(context, listen: false).logout();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => navigatePage),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(textMessage, style: TextStyle(fontSize: 16, color: Colors.grey)),
        InkWell(
          onTap: () => handleLogout(context),
          child: Text(
            textAuth,
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 114, 22, 26),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
