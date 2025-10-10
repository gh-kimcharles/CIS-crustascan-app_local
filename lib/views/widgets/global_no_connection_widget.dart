import 'package:flutter/material.dart';

class GlobalNoConnectionWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final bool isExpanded;

  const GlobalNoConnectionWidget({
    super.key,
    this.onRetry,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Internet Connection',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Please check your internet connection\nand try again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );

    return isExpanded ? Expanded(child: content) : content;
  }
}
