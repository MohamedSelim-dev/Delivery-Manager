import 'package:flutter/material.dart';
import 'package:flutter_app/models/order.dart';
import 'package:intl/intl.dart';

// === order item ===
class OrderItem extends StatelessWidget {
  final Order order;
  final Function removerOrder;
  OrderItem(this.order, this.removerOrder);
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).accentColor == Colors.grey[600];
    return Card(
      color: isDark
          ? Theme.of(context).primaryColor
          : Theme.of(context).accentColor,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
      ).add(
        EdgeInsets.only(bottom: 10),
      ),
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: !isDark ? Theme.of(context).primaryColor:Colors.black,
            radius: 30,
            child: FittedBox(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '${order.price.toStringAsFixed(2)}\$',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          title: Text(
            order.deliveryMan,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          subtitle: Text(DateFormat('hh:mm a').format(order.orderDate)),
          trailing: IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              removerOrder(
                  DateFormat('yyyyMMdd').format(order.orderDate), order);
            },
          ),
        ),
      ),
    );
  }
}
