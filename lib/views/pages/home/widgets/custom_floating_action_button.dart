import 'dart:io';
import 'package:crustascan_app/utils/helpers/connectivity_helper.dart';
import 'package:crustascan_app/views/pages/identifier/identifier_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({super.key});

  Future<void> _pickAndNavigate(
    BuildContext context,
    ImageSource source,
  ) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => IdentifierPage(imageFile: imageFile),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.large(
      onPressed: () {
        showModalBottomSheet(
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 60),
              height: 300,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Upload Image / Take Photo",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Choose an option to continue",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 20),

                    // Gallery Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          // First check internet connection
                          if (!await checkInternetOrShowDialog(
                            context,
                            title: "No Internet Connection",
                            description:
                                "Upload photo for prediction requires internet connection.",
                          )) {
                            return;
                          }
                          _pickAndNavigate(context, ImageSource.gallery);
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            240,
                            240,
                            240,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          "Upload Photo from Gallery",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Camera Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          // First check internet connection
                          if (!await checkInternetOrShowDialog(
                            context,
                            title: "No Internet Connection",
                            description:
                                "Taking photo for prediction requires internet connection.",
                          )) {
                            return;
                          }
                          _pickAndNavigate(context, ImageSource.camera);
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            240,
                            240,
                            240,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          "Take Image using Camera",
                          style: TextStyle(
                            color: Colors.black87,
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
          },
        );
      },
      shape: CircleBorder(),
      backgroundColor: const Color.fromARGB(255, 114, 22, 26),
      child: Icon(Icons.camera, color: Colors.white),
    );
  }
}
