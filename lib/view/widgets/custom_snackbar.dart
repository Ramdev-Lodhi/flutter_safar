import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static snackbar(String title, String message) {
    return Get.snackbar(title, message,
        messageText: Text(
          message,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        backgroundColor: title == 'Success' ? Colors.deepPurple : Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        icon:  title == 'Success' ? Icon(Icons.check_circle_rounded,color:Colors.white): Icon(Icons.error_rounded,color:Colors.white),
        // leftBarIndicatorColor: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20));
  }
  static snackbar_login(String title, String message) {
    return Get.snackbar(title, message,
        messageText: Text(
          message,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        backgroundColor: title == 'Success' ? Colors.deepPurple : Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        icon:  title == 'Success' ? Icon(Icons.check_circle_rounded,color:Colors.white): Icon(Icons.error_rounded,color:Colors.white),
        // leftBarIndicatorColor: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20));
  }
}
