import 'package:crustascan_app/services/config.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

class ImageHelper {
  /// Returns the full URL for any image path
  static String getImageUrl(String imagePath) {
    if (imagePath.isEmpty) {
      return 'assets/images/user/default_profile.png';
    }

    // Full URL
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    // Server path
    if (imagePath.startsWith('/uploads/')) {
      return '${AppConfig.apiBaseUrl}$imagePath';
    }

    // Asset path
    if (imagePath.startsWith('assets/')) {
      return imagePath;
    }

    // Default fallback
    return 'assets/images/user/default_profile.png';
  }

  /// Build an ImageProvider
  static ImageProvider getImageProvider(String imagePath) {
    if (imagePath.isEmpty) {
      return const AssetImage('assets/images/user/default_profile.png');
    }

    // Base64 image
    if (imagePath.startsWith('data:image')) {
      try {
        final base64Data = imagePath.split(',')[1];
        final bytes = base64Decode(base64Data);
        return MemoryImage(bytes);
      } catch (e) {
        debugPrint('Error decoding base64 image: $e');
        return const AssetImage('assets/images/user/default_profile.png');
      }
    }

    // Network image
    if (imagePath.startsWith('http://') ||
        imagePath.startsWith('https://') ||
        imagePath.startsWith('/uploads/')) {
      final url = getImageUrl(imagePath);
      return NetworkImage(url);
    }

    // Local file
    if (!imagePath.startsWith('assets/')) {
      try {
        return FileImage(File(imagePath));
      } catch (e) {
        debugPrint('Error loading file image: $e');
        return const AssetImage('assets/images/user/default_profile.png');
      }
    }

    // Asset image
    return AssetImage(imagePath);
  }

  static Widget buildImage({
    required String imagePath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? errorWidget,
  }) {
    if (imagePath.isEmpty) {
      return Image.asset(
        'assets/images/user/default_profile.png',
        width: width,
        height: height,
        fit: fit,
      );
    }

    // Base64 image
    if (imagePath.startsWith('data:image')) {
      try {
        final base64Data = imagePath.split(',')[1];
        final bytes = base64Decode(base64Data);
        return Image.memory(
          bytes,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) =>
              errorWidget ?? _defaultErrorWidget(width, height),
        );
      } catch (e) {
        debugPrint('Error decoding base64: $e');
        return errorWidget ?? _defaultErrorWidget(width, height);
      }
    }

    // Network image
    if (imagePath.startsWith('http://') ||
        imagePath.startsWith('https://') ||
        imagePath.startsWith('/uploads/')) {
      final url = getImageUrl(imagePath);
      debugPrint('Loading image from: $url');

      return Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Failed to load image: $url - Error: $error');
          return errorWidget ?? _defaultErrorWidget(width, height);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            width: width,
            height: height,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      );
    }

    // Local file
    if (!imagePath.startsWith('assets/')) {
      return Image.file(
        File(imagePath),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ?? _defaultErrorWidget(width, height),
      );
    }

    // Asset image
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) =>
          errorWidget ?? _defaultErrorWidget(width, height),
    );
  }

  static Widget _defaultErrorWidget(double? width, double? height) {
    return Container(
      width: width ?? 70,
      height: height ?? 70,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey.shade400,
        size: 24,
      ),
    );
  }
}
