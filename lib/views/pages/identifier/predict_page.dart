import 'dart:io';
import 'package:crustascan_app/providers/auth_provider.dart';
import 'package:crustascan_app/services/auth_service.dart';
import 'package:crustascan_app/views/pages/home/home_page.dart';
import 'package:crustascan_app/views/pages/identifier/widget/predict_description_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crustascan_app/providers/history_provider.dart';
import 'package:crustascan_app/models/history_model.dart';

class PredictPage extends StatelessWidget {
  final File imageFile;
  final String confidence; // IMPORTANT: Used to display prediction confidence.
  final String
  speciesId; // IMPORTANT: Used to display prediction class [10 species].
  final String type;
  final String speciesName;
  final String scientificName;
  final String familyName;
  final String population;
  final String description;

  const PredictPage({
    super.key,
    required this.imageFile,
    required this.confidence,
    required this.speciesId,
    required this.type,
    required this.speciesName,
    required this.scientificName,
    required this.familyName,
    required this.population,
    required this.description,
  });

  Future<void> _savePrediction(BuildContext context) async {
    final history = Provider.of<HistoryProvider>(context, listen: false);

    final serverImagePath = await AuthService().uploadHistoryImage(
      imageFile.path,
    );

    final newHistory = History(
      id: DateTime.now().millisecondsSinceEpoch,
      date: DateTime.now(),
      imagePath: serverImagePath,
      name: 'Saved_${speciesName.replaceAll(' ', '_')}',
      confidence: confidence,
      speciesId: speciesId,
    );

    await history.addHistory(context, newHistory);

    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Prediction saved successfully!'),
        duration: Duration(seconds: 2),
        backgroundColor: Color.fromARGB(255, 56, 168, 60),
      ),
    );

    Navigator.of(context).pop();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 600,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(imageFile),
                  fit: BoxFit.cover,
                ),
              ),
              // child: Align(
              //   alignment: Alignment(0, 0.75),
              //   child: Container(
              //     padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              //     decoration: BoxDecoration(
              //       color: const Color.fromARGB(255, 56, 168, 60),
              //       borderRadius: BorderRadius.circular(50),
              //     ),
              //     child: Text(
              //       confidence,
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 18,
              //       ),
              //     ),
              //   ),
              // ),
            ),
            Positioned(
              top: 550,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: PredictDescriptionContainer(
                    type: type,
                    name: speciesName,
                    scientificName: scientificName,
                    familyName: familyName,
                    population: population,
                    description: description,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (authProvider.isGuest) {
                        // If user is a guest, navigate directly to home page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      } else if (authProvider.isUser) {
                        // If user is not a guest, show the save/discard dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Save Prediction?'),
                            content: const Text(
                              'Do you want to save this prediction to history or discard it?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => _savePrediction(context),
                                child: const Text('Save'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomePage(),
                                    ),
                                  );
                                },
                                child: const Text('Discard'),
                              ),
                            ],
                          ),
                        );
                      }
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
