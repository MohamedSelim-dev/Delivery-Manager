import 'package:flutter/material.dart';

// === chart bar widget ===
class ChartBar extends StatelessWidget {
  final double height;
  final Color color;
  final String name;
  final int numberOfOrders;

  const ChartBar(
      {@required this.height,
      @required this.color,
      @required this.name,
      @required this.numberOfOrders});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      padding: EdgeInsets.all(8),
      message: 'Name : $name \n#Orders : $numberOfOrders',
      textStyle: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 2,
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 20,
        height: height,
        color: color,
      ),
    );
  }
}
