import 'package:crustascan_app/data/_list.dart';
import 'package:crustascan_app/views/pages/settings/settings_page.dart';
import 'package:crustascan_app/views/pages/settings/widgets/settings-footer-container.dart';
import 'package:crustascan_app/views/pages/settings/widgets/settings-header-container.dart';
import 'package:crustascan_app/views/widgets/global-appbar.dart';
import 'package:flutter/material.dart';

class DataPolicyPage extends StatelessWidget {
  final bool popOnly;

  const DataPolicyPage({super.key, this.popOnly = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(
        text: "Data Policy",
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
                  SizedBox(height: 20),
                  SettingsHeaderContainer(
                    text: "Data Policy",
                    description:
                        "Learn how we collect, use, and protect your data.",
                  ),
                  SizedBox(height: 20),
                  ...dataPolicyList.map(
                    (item) => PolicyContainer(
                      text: item['title']!,
                      description: item['description']!,
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

class PolicyContainer extends StatelessWidget {
  final String text;
  final String description;

  const PolicyContainer({
    super.key,
    required this.text,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          SizedBox(
            width: 400,
            child: Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          Divider(thickness: 1, indent: 30, endIndent: 30),
        ],
      ),
    );
  }
}
