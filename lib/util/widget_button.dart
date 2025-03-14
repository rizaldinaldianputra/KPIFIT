import 'package:flutter/material.dart';
import 'package:kpifit/config/colors.dart';

Widget button(String title, VoidCallback onTap, Color color) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.all(20),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}

Widget listTile(IconData icons, String title, VoidCallback ontap) {
  return ListTile(
      leading: Icon(
        icons,
        color: secondaryColor,
      ),
      title: Text(title),
      onTap: ontap);
}
