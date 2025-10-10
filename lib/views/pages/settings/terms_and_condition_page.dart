import 'package:crustascan_app/data/_list.dart';
import 'package:crustascan_app/views/pages/settings/settings_page.dart';
import 'package:crustascan_app/views/pages/settings/widgets/settings-footer-container.dart';
import 'package:crustascan_app/views/pages/settings/widgets/settings-header-container.dart';
import 'package:crustascan_app/views/widgets/global-appbar.dart';
import 'package:flutter/material.dart';

class TermsAndConditionPage extends StatelessWidget {
  final bool popOnly;

  const TermsAndConditionPage({super.key, this.popOnly = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(
        text: "Terms & Condition",
        navigatePage: const SettingsPage(),
        popOnly: popOnly, // uses the value passed to the screen
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  SettingsHeaderContainer(
                    text: "Terms & Condition",
                    description:
                        "Read the rules and guidelines for using our services.",
                  ),
                  ...termsAndConditionList.map(
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

class TermsAndConditionContainer extends StatelessWidget {
  final String text;
  final String description;

  const TermsAndConditionContainer({
    super.key,
    required this.text,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          SizedBox(height: 20),
          Divider(thickness: 1, indent: 30, endIndent: 30),
        ],
      ),
    );
  }
}
