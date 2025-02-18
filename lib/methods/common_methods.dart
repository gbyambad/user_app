import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class CommonMethods {
  checkConnectivity(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      if (!context.mounted) return;
      displaySnackBar(
          "Your Internet is not available. Check your internet connection and try again.",
          context);
    }
  }

  displaySnackBar(String messageText, BuildContext context) {
    var snackbar = SnackBar(
      content: Text(messageText),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
