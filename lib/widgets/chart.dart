import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/order.dart';
import 'package:flutter_app/widgets/chart_bar.dart';
import 'package:flutter_app/widgets/hero_item.dart';
import 'package:intl/intl.dart';

// === widget chart ===
class Chart extends StatefulWidget {
  final DateTime selectedDate;
  final Function changedSelectedDate;
  final SplayTreeSet<Order> selectedOrders;

  Chart(this.selectedDate, this.changedSelectedDate, this.selectedOrders);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  Map<String, int> count;

  void filter() {
    count = Map<String, int>();
    if (widget.selectedOrders != null) {
      widget.selectedOrders.forEach((element) {
        if (count.containsKey(element.deliveryMan)) {
          count[element.deliveryMan]++;
        } else {
          count[element.deliveryMan] = 1;
        }
      });
    }
  }

  // === method calc constrains maxHeight ====
  double calcHeight(int ordersCount, BoxConstraints constraints) {
    return ordersCount * constraints.maxHeight / 20;
  }

  @override
  Widget build(BuildContext context) {
    filter();
    return Card(
      color: Theme.of(context).accentColor,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
      ).add(EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8),
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                child: ListView.builder(
                  reverse: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    // === current date ===
                    DateTime currentDate = DateTime.now().subtract(
                      Duration(days: index),
                    );

                    // === catch current date tabbed now ===
                    String date = DateFormat('dd/MM').format(currentDate);
                    bool selected =
                        DateFormat('dd/MM/yyyy').format(widget.selectedDate) ==
                            DateFormat('dd/MM/yyyy').format(currentDate);

                    return Container(
                      margin: EdgeInsets.only(
                        left: index != 6 ? 2 : 0,
                        right: index != 0 ? 2 : 0,
                      ),
                      child: FlatButton(
                        shape: StadiumBorder(),
                        child: Text(date),
                        color: selected ? Colors.amber : Colors.amber[100],
                        onPressed: () {
                          widget.changedSelectedDate(currentDate);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: widget.selectedOrders != null &&
                      widget.selectedOrders.isNotEmpty
                  ? Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Text('#Orders'),
                              SizedBox(
                                width: 100,
                              ),
                              Expanded(
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    HeroItem(
                                      Colors.blue,
                                      'Mohamed',
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    HeroItem(
                                      Colors.yellow,
                                      'Dalia',
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    HeroItem(
                                      Colors.purple,
                                      'Judi',
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    HeroItem(
                                      Colors.green,
                                      'Adam',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    height: constraints.maxHeight,
                                    width: constraints.maxWidth * 0.1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('20'),
                                        Text('10'),
                                        Text('0'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    height: constraints.maxHeight,
                                    width: constraints.maxWidth * 0.9,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (count.containsKey('Mohamed'))
                                          ChartBar(
                                            height: calcHeight(
                                                count['Mohamed'], constraints),
                                            color: Colors.blue,
                                            name: 'Mohamed',
                                            numberOfOrders: count['Mohamed'],
                                          ),
                                        if (count.containsKey('Dalia'))
                                          ChartBar(
                                            height: calcHeight(
                                                count['Dalia'], constraints),
                                            color: Colors.yellow,
                                            name: 'Dalia',
                                            numberOfOrders: count['Dalia'],
                                          ),
                                        if (count.containsKey('Judi'))
                                          ChartBar(
                                            height: calcHeight(
                                                count['Judi'], constraints),
                                            color: Colors.purple,
                                            name: 'Judi',
                                            numberOfOrders: count['Judi'],
                                          ),
                                        if (count.containsKey('Adam'))
                                          ChartBar(
                                            height: calcHeight(
                                                count['Adam'], constraints),
                                            color: Colors.green,
                                            name: 'Adam',
                                            numberOfOrders: count['Adam'],
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Text('no orders'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
