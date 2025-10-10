import 'package:crustascan_app/data/_list.dart';
import 'package:crustascan_app/views/pages/profile/profile_page.dart';
import 'package:crustascan_app/views/pages/settings/terms_and_condition_page.dart';
import 'package:crustascan_app/views/pages/settings/widgets/settings-footer-container.dart';
import 'package:crustascan_app/views/pages/settings/widgets/settings-header-container.dart';
import 'package:crustascan_app/views/widgets/global-appbar.dart';
import 'package:flutter/material.dart';

class PrivacyAndSecurity extends StatelessWidget {
  const PrivacyAndSecurity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(
        text: "Privacy & Security",
        navigatePage: ProfilePage(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  SettingsHeaderContainer(
                    text: "Privacy & Security",
                    description:
                        "Protect your privacy and keep your account safe.",
                  ),
                  // Use the TermsAndConditionContainer for Privacy & Security container.
                  ...privacyAndSecurityList.map(
                    (term) => TermsAndConditionContainer(
                      text: term['title']!,
                      description: term['description']!,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            SettingsFooterContainer(),
          ],
        ),
      ),
    );
  }
}
