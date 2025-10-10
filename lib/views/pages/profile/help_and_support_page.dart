import 'package:crustascan_app/views/pages/profile/widgets/help_and_support_tile.dart';
import 'package:flutter/material.dart';
import 'package:crustascan_app/views/pages/profile/profile_page.dart';
import 'package:crustascan_app/views/pages/settings/widgets/settings-footer-container.dart';
import 'package:crustascan_app/views/pages/settings/widgets/settings-header-container.dart';
import 'package:crustascan_app/views/widgets/global-appbar.dart';
import 'package:crustascan_app/data/_list.dart';

class HelpAndSupportPage extends StatelessWidget {
  const HelpAndSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(text: "Help & Support", navigatePage: ProfilePage()),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  SettingsHeaderContainer(
                    text: "Help & Support",
                    description: "Frequently asked questions and usage tips",
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: helpAndSupportList.map((item) {
                      return HelpAndSupportTile(
                        title: item['title']!,
                        description: item['description']!,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            const SettingsFooterContainer(),
          ],
        ),
      ),
    );
  }
}
