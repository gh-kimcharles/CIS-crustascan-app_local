import 'package:crustascan_app/utils/helpers/image_helper.dart';
import 'package:crustascan_app/utils/helpers/connectivity_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:crustascan_app/providers/user_provider.dart';

class CustomEditImageModalBottomSheet extends StatelessWidget {
  const CustomEditImageModalBottomSheet({super.key});

  Future<void> _pickAndNavigate(
    BuildContext context,
    ImageSource source,
  ) async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile;

    try {
      pickedFile = await picker.pickImage(source: source);
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to select image'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (pickedFile == null) {
      if (context.mounted) Navigator.pop(context);
      return;
    }

    if (!context.mounted) return;

    // Close the modal first
    Navigator.pop(context);

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // ✅ QUICK FIX: Clear image cache before updating
      final oldImagePath = userProvider.user.imagePath;
      if (oldImagePath.contains('/uploads/') ||
          oldImagePath.startsWith('http')) {
        // Clear both image caches
        imageCache.clear();
        imageCache.clearLiveImages();
      }

      // Update the profile image
      await userProvider.updateProfileImage(pickedFile.path);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile image updated successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error updating profile image: $e');
      if (context.mounted) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile image: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = Provider.of<UserProvider>(context).user.imagePath;

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
                width: double.infinity,
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
                    ElevatedButton(
                      onPressed: () async {
                        if (!await checkInternetOrShowDialog(
                          context,
                          title: "No Internet Connection",
                          description:
                              "Upload photo requires internet connection.",
                        )) {
                          return;
                        }
                        _pickAndNavigate(context, ImageSource.gallery);
                      },
                      style: _buttonStyle(),
                      child: const Text(
                        "Upload Photo from Gallery",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Camera Button
                    ElevatedButton(
                      onPressed: () async {
                        if (!await checkInternetOrShowDialog(
                          context,
                          title: "No Internet Connection",
                          description:
                              "Taking photo requires internet connection.",
                        )) {
                          return;
                        }
                        _pickAndNavigate(context, ImageSource.camera);
                      },
                      style: _buttonStyle(),
                      child: const Text(
                        "Take Image using Camera",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Stack(
          children: [
            CircleAvatar(
              radius: 70,
              backgroundImage: ImageHelper.getImageProvider(imagePath),
              key: ValueKey(imagePath), // Force rebuild when path changes
            ),
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
                child: const Icon(Icons.edit, size: 20, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFF0F0F0),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }
}
