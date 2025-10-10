import 'dart:io';
import 'package:crustascan_app/providers/register_user_image_provider.dart';
import 'package:crustascan_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CustomImageModalBottomSheet extends StatelessWidget {
  const CustomImageModalBottomSheet({super.key});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final auth = AuthService();
      final uploadedPath = await auth.uploadProfileImage(pickedFile.path);

      // Update provider with uploaded image path
      Provider.of<RegisterUserImageProvider>(
        context,
        listen: false,
      ).setImagePath(uploadedPath);
    }

    Navigator.pop(context); // Close the bottom sheet
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = context.watch<RegisterUserImageProvider>().imagePath;

    ImageProvider imageProvider;
    if (imagePath.startsWith('http')) {
      imageProvider = NetworkImage(imagePath);
    } else if (imagePath.startsWith('assets/')) {
      imageProvider = AssetImage(imagePath);
    } else {
      final file = File(imagePath);
      imageProvider = file.existsSync()
          ? FileImage(file)
          : const AssetImage('assets/images/user/default_profile.png');
    }

    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            backgroundColor: Colors.white,
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                height: 300,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Upload Image / Take Photo",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Choose an option to continue",
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 20),

                      // Gallery Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              _pickImage(context, ImageSource.gallery),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF0F0F0),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "Upload Photo from Gallery",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Camera Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              _pickImage(context, ImageSource.camera),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF0F0F0),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "Take Image using Camera",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Stack(
          children: [
            CircleAvatar(radius: 70, backgroundImage: imageProvider),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.person, size: 20, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
