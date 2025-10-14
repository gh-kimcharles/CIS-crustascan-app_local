import 'package:crustascan_app/services/config.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

class ImageHelper {
  /// Returns the full URL for any image path
  static String getImageUrl(String imagePath) {
    if (imagePath.isEmpty) {
      debugPrint('⚠️ ImageHelper: Empty image path');
      return 'assets/images/user/default_profile.png';
    }

    // Full URL
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      debugPrint('✅ ImageHelper: Full URL detected: $imagePath');
      return imagePath;
    }

    // Server path - THIS IS THE KEY FIX
    if (imagePath.startsWith('/uploads/')) {
      final fullUrl = '${AppConfig.baseUrl}$imagePath';
      debugPrint('✅ ImageHelper: Server path converted to: $fullUrl');
      return fullUrl;
    }

    // Asset path
    if (imagePath.startsWith('assets/')) {
      debugPrint('✅ ImageHelper: Asset path: $imagePath');
      return imagePath;
    }

    // Default fallback
    debugPrint(
      '⚠️ ImageHelper: Unknown path format, using default: $imagePath',
    );
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
        debugPrint('❌ Error decoding base64 image: $e');
        return const AssetImage('assets/images/user/default_profile.png');
      }
    }

    // Network image
    if (imagePath.startsWith('http://') ||
        imagePath.startsWith('https://') ||
        imagePath.startsWith('/uploads/')) {
      final url = getImageUrl(imagePath);
      debugPrint('🌐 Loading network image: $url');
      return NetworkImage(url);
    }

    // Local file
    if (!imagePath.startsWith('assets/')) {
      try {
        return FileImage(File(imagePath));
      } catch (e) {
        debugPrint('❌ Error loading file image: $e');
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
          errorBuilder: (context, error, stackTrace) {
            debugPrint('❌ Base64 image error: $error');
            return errorWidget ?? _defaultErrorWidget(width, height);
          },
        );
      } catch (e) {
        debugPrint('❌ Error decoding base64: $e');
        return errorWidget ?? _defaultErrorWidget(width, height);
      }
    }

    // Network image
    if (imagePath.startsWith('http://') ||
        imagePath.startsWith('https://') ||
        imagePath.startsWith('/uploads/')) {
      final url = getImageUrl(imagePath);
      debugPrint('🌐 Building network image widget: $url');

      return Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('❌ Failed to load image: $url');
          debugPrint('❌ Error: $error');
          debugPrint('❌ StackTrace: $stackTrace');
          return errorWidget ?? _defaultErrorWidget(width, height);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            debugPrint('✅ Image loaded successfully: $url');
            return child;
          }
          return SizedBox(
            width: width,
            height: height,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 2,
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
        errorBuilder: (context, error, stackTrace) {
          debugPrint('❌ File image error: $error');
          return errorWidget ?? _defaultErrorWidget(width, height);
        },
      );
    }

    // Asset image
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('❌ Asset image error: $error');
        return errorWidget ?? _defaultErrorWidget(width, height);
      },
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            color: Colors.grey.shade400,
            size: 24,
          ),
          SizedBox(height: 4),
          Text(
            'Failed',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
