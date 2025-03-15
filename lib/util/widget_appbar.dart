import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

AppBar buildGradientAppBar(BuildContext context, String title) {
  return AppBar(
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
      onPressed: () => Navigator.of(context).pop(),
    ),
    title: Text(
      title,
      style: const TextStyle(color: Colors.white, fontSize: 18),
    ),
    actions: [],
    flexibleSpace: Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [HexColor('#01A2E9'), HexColor('#274896')],
        ),
      ),
    ),
  );
}
