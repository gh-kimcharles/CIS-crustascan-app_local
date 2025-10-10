import 'package:crustascan_app/data/crustacean_data.dart';
import 'package:crustascan_app/models/crustacean_model.dart';
import 'package:crustascan_app/models/history_model.dart';
import 'package:crustascan_app/services/config.dart';
import 'package:crustascan_app/views/pages/history/history_page.dart';
import 'package:crustascan_app/views/pages/history/widgets/history_description_container.dart';
import 'package:crustascan_app/utils/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class HistoryDetailsPage extends StatelessWidget {
  final History history;

  const HistoryDetailsPage({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final Crustacean species = crustaceanList.firstWhere(
      (speciesItem) => speciesItem.id == history.speciesId,
      orElse: () {
        throw Exception("Species with id '${history.speciesId}' not found.");
      },
    );

    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Background image container
            Container(
              width: double.infinity,
              height: 600,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ImageHelper.getImageProvider(history.imagePath),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    debugPrint('Error loading image: $exception');
                  },
                ),
              ),
            ),
            // Overlapping description container
            Positioned(
              top: 550,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: HistoryDescriptionContainer(
                    crustacean: species,
                    name: species.name,
                    type: species.type,
                    scientificName: species.scientificName,
                    familyName: species.familyName,
                    population: species.population,
                    shortDescription: species.shortDescription,
                  ),
                ),
              ),
            ),
            // Back button
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HistoryPage(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
