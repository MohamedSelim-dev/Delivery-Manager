import 'package:flutter/material.dart';

// === hero item widget ===
class HeroItem extends StatelessWidget {
  final Color color;
  final String name;

  HeroItem(this.color, this.name);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          color: color,
        ),
        SizedBox(
          width: 2,
        ),
        Text(name),
      ],
    );
  }
}
