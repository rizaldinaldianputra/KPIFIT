import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

notifikasiFailed(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 13);
}

notifikasiSuccess(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 13);
}

notifikasiAuth(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 13);
}

notifikasiLocal(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
      fontSize: 13);
}
