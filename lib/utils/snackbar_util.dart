import 'package:flutter/material.dart';

void showSnackBar({
  required BuildContext context,
  required String message,
}) {
  if (message.isEmpty) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message,style: TextStyle(fontSize: 16, color: Colors.black),),
      duration: const Duration(seconds: 3), 
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.white,
      margin: const EdgeInsets.only(
        bottom: 10.0, 
        left: 16.0,
        right: 16.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 8.0,
    ),
  );
}
