import 'package:crustascan_app/providers/auth_provider.dart';
import 'package:crustascan_app/providers/guest_provider.dart';
import 'package:crustascan_app/providers/history_provider.dart';
import 'package:crustascan_app/providers/user_provider.dart';
import 'package:crustascan_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileSectionContainer extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? navigatePage; // Accepts null widget screen - for clear history.
  final bool isClearHistory;
  final bool isLogout;

  const ProfileSectionContainer({
    super.key,
    required this.icon,
    required this.title,
    this.navigatePage,
    this.isClearHistory = false,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isLogout) {
          // Show confirmation dialog
          showDialog(
            context: context,
            builder: (context) =>
                ShowAlertDialogLogout(navigatePage: navigatePage!),
          );
        } else if (isClearHistory) {
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            builder: (context) => const ClearHistoryModalSheetButton(),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => navigatePage!),
          );
        }
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 55,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: icon == Icons.exit_to_app ? Colors.red : Colors.black,
            ),
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: icon == Icons.exit_to_app ? Colors.red : Colors.black,
              ),
            ),
            Spacer(),

            // If icon is Icons.history, remove Icons.exit_to_app.
            if (icon != Icons.history) Icon(Icons.arrow_forward_ios, size: 22),
          ],
        ),
      ),
    );
  }
}

class ClearHistoryModalSheetButton extends StatelessWidget {
  const ClearHistoryModalSheetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 60),
      height: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Clear History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              "This action cannot be undone.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await Provider.of<HistoryProvider>(
                    context,
                    listen: false,
                  ).clearHistory(context);

                  Navigator.pop(context); // close dialog/screen if you want
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Clear",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ShowAlertDialogLogout extends StatelessWidget {
  final Widget navigatePage;
  const ShowAlertDialogLogout({super.key, required this.navigatePage});

  @override
  Widget build(BuildContext context) {
    Future<void> _logout() async {
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

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text("Confirm Logout"),
      content: Text("Are you sure you want to log out?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            await _logout();
          },
          child: Text("Log Out"),
        ),
      ],
    );
  }
}
