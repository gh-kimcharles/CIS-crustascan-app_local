import 'package:crustascan_app/views/pages/settings/settings_page.dart';
import 'package:crustascan_app/views/pages/settings/widgets/settings-footer-container.dart';
import 'package:crustascan_app/views/pages/settings/widgets/settings-header-container.dart';
import 'package:crustascan_app/views/widgets/global-appbar.dart';
import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(text: "About Us", navigatePage: SettingsPage()),
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
                    text: "About Us",
                    description: "Meet the team.",
                  ),
                  SizedBox(height: 20),
                  AboutUsContainer(
                    imagePath: "assets/images/about_us/kobe_dev.jpg",
                    name: "Kobe Lester Cruz",
                    contribution: "Backend Developer",
                  ),
                  AboutUsContainer(
                    imagePath: "assets/images/about_us/kim_dev.jpg",
                    name: "Kim Charles De Guzman",
                    contribution: "Fullstack Developer",
                  ),
                  AboutUsContainer(
                    imagePath: "assets/images/about_us/alfred_dev.jpg",
                    name: "Alfred Anthony Lapuz",
                    contribution: "Application Tester",
                  ),
                  AboutUsContainer(
                    imagePath: "assets/images/about_us/djohn_dev.jpg",
                    name: "Djohn Paul Turla",
                    contribution: "Frontend Developer",
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

class AboutUsContainer extends StatelessWidget {
  final String imagePath;
  final String name;
  final String contribution;

  const AboutUsContainer({
    super.key,
    required this.imagePath,
    required this.name,
    required this.contribution,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(thickness: 1, indent: 30, endIndent: 30),
          SizedBox(height: 20),
          CircleAvatar(radius: 50, backgroundImage: AssetImage(imagePath)),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            contribution,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
