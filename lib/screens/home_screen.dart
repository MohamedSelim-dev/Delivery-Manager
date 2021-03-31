import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/models/order.dart';
import 'package:flutter_app/widgets/add_order_sheet.dart';
import 'package:flutter_app/widgets/chart.dart';
import 'package:flutter_app/widgets/order_item.dart';
import 'package:flutter_app/widgets/sticky_head.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final Function toggleTheme;

  HomeScreen(this.toggleTheme);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController controller = ScrollController();
  bool showUpButton = false;

  // === list of delivery man ===
  List<String> deliveryMen = ['Dalia', 'Mohamed', 'Judi', 'Adam'];

  // === sort date by Map of Orders ===
  SplayTreeMap<String, Map<String, dynamic>> orders =
      SplayTreeMap<String, Map<String, dynamic>>((String a, String b) {
    return -a.compareTo(b);
  });

  DateTime selectedDate;
  SplayTreeSet<Order> selectedOrders;


  bool isDark;

  @override
  void initState() {
    super.initState();
    isDark =false;
    selectedDate = DateTime.now();

    // === order list generate ===
    final ordersList = List.generate(12, (index) {
      return Order(
        deliveryMan: deliveryMen[Random().nextInt(3)],
        price: Random().nextDouble() * 500,
        orderDate: DateTime.now().subtract(
          Duration(
            days: Random().nextInt(12),
            hours: Random().nextInt(24),
            minutes: Random().nextInt(60),
          ),
        ),
      );
    });

    // === order list loop  ===
    ordersList.forEach((element) {
      final key = DateFormat('yyyyMMdd').format(element.orderDate);
      if (!orders.containsKey(key)) {
        orders[key] = Map<String, dynamic>();
        orders[key]['date'] =
            DateFormat('EEEE, dd/MM/yyyy').format(element.orderDate);
        orders[key]['list'] = SplayTreeSet((Order a, Order b) {
          return -a.orderDate.compareTo(b.orderDate);
        });
      }
      orders[key]['list'].add(element);
    });

    String key = DateFormat('yyyyMMdd').format(selectedDate);
    if (orders.containsKey(key)) {
      selectedOrders = orders[key]['list'];
    } else {
      selectedOrders = null;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // === method Add Order ===
  void addOrder(String key, Order order) {
    setState(() {
      Navigator.of(context).pop();
      if (orders.containsKey(key)) {
        orders[key]['list'].add(order);
      } else {
        orders[key] = Map<String, dynamic>();
        orders[key]['date'] =
            DateFormat('EEEE, dd/MM/yyyy').format(order.orderDate);
        orders[key]['list'] = SplayTreeSet<Order>((Order a, Order b) {
          return -a.orderDate.compareTo(b.orderDate);
        });
        orders[key]['list'].add(order);
      }
    });
  }

  // === method Remove order ===
  void removeOrder(String key, Order order) {
    setState(() {
      (orders[key]['list'] as SplayTreeSet<Order>).remove(order);
      if (orders[key]['list'].isEmpty) {
        orders.remove(key);
      }
    });
  }

  //=== method changed selected date ===
  void changedSelectedDate(DateTime date) {
    setState(() {
      selectedDate = date;
      String key = DateFormat('yyyyMMdd').format(selectedDate);
      if (orders.containsKey(key)) {
        selectedOrders = orders[key]['list'];
      } else {
        selectedOrders = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
          ),
          SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.05),
                    child: Text(
                      'Delivery Manager',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Chart(selectedDate, changedSelectedDate, selectedOrders),
                  Expanded(
                    child: NotificationListener<ScrollUpdateNotification>(
                      // ignore: missing_return
                      onNotification: (notification) {
                        if (notification.metrics.pixels > 40 &&
                            showUpButton == false) {
                          setState(() {
                            showUpButton = true;
                          });
                        } else if (notification.metrics.pixels < 40 &&
                            showUpButton == true) {
                          setState(() {
                            showUpButton = false;
                          });
                        }
                      },
                      child: ListView.builder(
                        controller: controller,
                        padding: EdgeInsets.only(
                            bottom: kFloatingActionButtonMargin + 56),
                        physics: BouncingScrollPhysics(),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          List<String> keys = orders.keys.toList();
                          String key = keys[index];
                          String date = orders[key]['date'];
                          SplayTreeSet<Order> list = orders[key]['list'];
                          return StickyHeader(
                            header: StickyHeaderHead(date),
                            content: Column(
                              children: list.map((element) {
                                return OrderItem(element, removeOrder);
                              }).toList(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 2 * kFloatingActionButtonMargin),
        child: Row(
          mainAxisAlignment: (showUpButton)
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.end,
          children: [
            if (showUpButton)

              // === moving up button ===
              FloatingActionButton(
                mini: true,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.keyboard_arrow_up,
                  color: Colors.white,
                ),
                onPressed: () {
                  controller.jumpTo(0.0);
                },
              ),

            Spacer(),

            //=== switch button ===
            Switch(
              value: isDark,
              onChanged: (value){
                setState(() {
                  isDark=value;
                });
                widget.toggleTheme();
              },
            ),

            // === add button ===
            FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return AddOrderSheet(deliveryMen, addOrder);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
