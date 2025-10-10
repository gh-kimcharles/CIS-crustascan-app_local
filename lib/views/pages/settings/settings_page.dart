import 'package:crustascan_app/views/pages/profile/profile_page.dart';
import 'package:crustascan_app/views/pages/settings/about_us.dart';
import 'package:crustascan_app/views/pages/settings/data_policy_page.dart';
import 'package:crustascan_app/views/pages/settings/terms_and_condition_page.dart';
import 'package:crustascan_app/views/pages/settings/widgets/settings-container.dart';
import 'package:crustascan_app/views/widgets/global-appbar.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(text: "Settings", navigatePage: ProfilePage()),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 12),
              SettingsContainer(
                icon: Icons.policy,
                title: "Data Policy",
                navigatePage: DataPolicyPage(),
              ),
              SettingsContainer(
                icon: Icons.description,
                title: "Terms & Condition",
                navigatePage: TermsAndConditionPage(),
              ),
              SettingsContainer(
                icon: Icons.info,
                title: "About Us",
                navigatePage: AboutUsPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class SettingsBox extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final Widget destination;

//   const SettingsBox({
//     required this.icon,
//     required this.title,
//     required this.destination,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: 10),
//       child: Container(
//         height: 55,
//         width: double.infinity,
//         decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
//         child: Row(
//           children: [
//             Icon(icon, size: 25),
//             Spacer(flex: 1),
//             Text(
//               title,
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             Spacer(flex: 6),
//             IconButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => destination),
//                 );
//               },
//               icon: Icon(Icons.arrow_forward_ios),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
