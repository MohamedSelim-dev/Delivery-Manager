import 'package:flutter/material.dart';

// === widget bottom sheet title ===
class BottomSheetItemTitle extends StatelessWidget {
  final String title;
  BottomSheetItemTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
