import 'package:crustascan_app/providers/auth_provider.dart';
import 'package:crustascan_app/utils/helpers/image_helper.dart';
import 'package:crustascan_app/views/pages/auth/login_page.dart';
import 'package:crustascan_app/views/pages/auth/register_page.dart';
import 'package:crustascan_app/views/pages/profile/edit_profile_page.dart';
import 'package:crustascan_app/views/pages/profile/help_and_support_page.dart';
import 'package:crustascan_app/views/pages/profile/privacy_and_security.dart';
import 'package:crustascan_app/views/pages/profile/widgets/custom_bottom_nav_is_guest.dart';
import 'package:crustascan_app/views/pages/profile/widgets/profile_section_container.dart';
import 'package:crustascan_app/views/pages/settings/settings_page.dart';
import 'package:crustascan_app/views/pages/home/home_page.dart';
import 'package:crustascan_app/views/widgets/global-appbar.dart';
import 'package:crustascan_app/views/widgets/global-logo-header-container.dart';
import 'package:crustascan_app/views/widgets/global_loading_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crustascan_app/providers/user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(text: "Profile", navigatePage: HomePage()),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              if (authProvider.isGuest) ...[
                const SizedBox(height: 40),
                const GlobalLogoHeaderContainer(
                  text: "Welcome to CrustaScan!",
                  description: "Create account for personal account!",
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.shade200, width: 1),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_add_alt_1,
                        color: Colors.blue.shade700,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Sign Up for a Personalized Experience:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade900,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "• Secure, personalized user authentication.\n"
                              "• Save species to favorites for future reference.\n"
                              "• Store predictions in your personal history.",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.blue.shade800,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

              if (authProvider.isUser) ...[
                const SizedBox(height: 12),
                Hero(
                  tag: "profile-picture",
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: ImageHelper.getImageProvider(
                      user.imagePath,
                    ),
                    key: ValueKey(user.imagePath),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "${user.firstName} ${user.lastName}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  user.email,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 24),
              ],

              // ProfileDarkModeContainer(
              //   isSwitched: _isSwitched,
              //   onChangedToggleSwitch: (value) {
              //     setState(() {
              //       _isSwitched = value;
              //     });
              //   },
              // ),
              if (authProvider.isUser) ...[
                ProfileSectionContainer(
                  icon: Icons.edit,
                  title: "Profile Information",
                  navigatePage: EditProfilePage(),
                ),
                ProfileSectionContainer(
                  icon: Icons.history,
                  title: "Clear History",
                  isClearHistory: true,
                  navigatePage: null,
                ),
              ],

              const Divider(thickness: 1, indent: 30, endIndent: 30),
              ProfileSectionContainer(
                icon: Icons.privacy_tip,
                title: "Privacy & Security",
                navigatePage: PrivacyAndSecurity(),
              ),
              ProfileSectionContainer(
                icon: Icons.help,
                title: "Help & Support",
                navigatePage: HelpAndSupportPage(),
              ),
              ProfileSectionContainer(
                icon: Icons.settings,
                title: "Settings",
                navigatePage: SettingsPage(),
              ),
              const Divider(thickness: 1, indent: 30, endIndent: 30),
              ...(authProvider.isGuest
                  ? [
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            CustomBottomNavIsGuest(
                              navigatePage: GlobalLoadingPage(
                                navigateNextPage: RegisterPage(),
                                duration: Duration(seconds: 1),
                              ),
                              textMessage: "Don't have an account? ",
                              textAuth: "Register!",
                            ),
                            const SizedBox(height: 70),
                          ],
                        ),
                      ),
                    ]
                  : [
                      const Spacer(),
                      ProfileSectionContainer(
                        icon: Icons.exit_to_app,
                        title: "Log Out",
                        isLogout: true,
                        navigatePage: GlobalLoadingPage(
                          navigateNextPage: LoginPage(),
                          duration: Duration(seconds: 2),
                        ),
                      ),
                      const Divider(thickness: 1, indent: 30, endIndent: 30),
                      const SizedBox(height: 20),
                    ]),
            ],
          ),
        ),
      ),
    );
  }
}

// class ProfileDarkModeContainer extends StatelessWidget {
//   final bool isSwitched;
//   final Function(bool) onChangedToggleSwitch;

//   const ProfileDarkModeContainer({
//     super.key,
//     required this.isSwitched,
//     required this.onChangedToggleSwitch,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 55,
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
//       child: Row(
//         children: [
//           Icon(isSwitched ? Icons.light_mode : Icons.dark_mode, size: 22),
//           SizedBox(width: 20),
//           Text(
//             isSwitched ? "Light Mode" : "Dark Mode",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           Spacer(),
//           Switch(value: isSwitched, onChanged: onChangedToggleSwitch),
//         ],
//       ),
//     );
//   }
// }
