import 'package:crustascan_app/services/network_service.dart';
import 'package:crustascan_app/views/widgets/global_internet_required_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> checkInternetOrShowDialog(
  BuildContext context, {
  String? title,
  String? description,
  String? buttonText,
  VoidCallback? onPressed,
}) async {
  final hasInternet = await NetworkService.hasInternetConnection();
  if (!hasInternet) {
    if (!context.mounted) return false;
    GlobalInternetRequiredDialog.show(
      context,
      title: title,
      description: description,
      buttonText: buttonText,
      onPressed: onPressed,
    );
    return false;
  }
  return true;
}
