import 'package:flutter/material.dart';
import 'package:flutter_app/models/order.dart';
import 'package:flutter_app/widgets/bottom_sheet_item_title.dart';
import 'package:intl/intl.dart';

//=== Add Order Screen ===
class AddOrderSheet extends StatefulWidget {
  final List<String> deliveryMen;
  final Function addOrder;
  AddOrderSheet(this.deliveryMen,this.addOrder);
  @override
  _AddOrderSheetState createState() => _AddOrderSheetState();
}

class _AddOrderSheetState extends State<AddOrderSheet> {
  String selectedDeliveryMan;
  DateTime selectedDated;
  TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    selectedDeliveryMan = widget.deliveryMen[0];
    selectedDated = DateTime.now();
    priceController = TextEditingController();
  }

  @override
  void dispose() {
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).accentColor,
      width: double.infinity,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //=== bottom sheet title lets add an order ===
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              color: Theme.of(context).primaryColor,
              child: Text(
                'Let\'s add an order',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            //=== add order screen ===
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //=== title (who 'll deliver?) ===
                  BottomSheetItemTitle('Who\'ll deliver?'),
                  //=== select delivery man ===
                  Card(
                    elevation: 5,
                    color: Colors.blue[100],
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            isExpanded: true,
                            value: selectedDeliveryMan,
                            items: widget.deliveryMen.map((e) {
                              return DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedDeliveryMan = value;
                              });
                            }),
                      ),
                    ),
                  ),
                  //=== title (when 'll be delivered?) ===
                  BottomSheetItemTitle('When\'ll be delivered?'),
                  //=== select date and time ===
                  Row(
                    children: [
                      // === select Date ===
                      RaisedButton(
                        child: Text(
                          DateFormat('EEEE, dd/MM/yyyy').format(selectedDated),
                        ),
                        color: Colors.blue[100],
                        onPressed: () async {
                          DateTime pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDated,
                            firstDate: DateTime.now().subtract(
                              Duration(days: 7),
                            ),
                            lastDate: DateTime.now().add(
                              Duration(days: 30),
                            ),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              selectedDated = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                selectedDated.hour,
                                selectedDated.minute,
                              );
                            });
                          }
                        },
                      ),

                      Container(
                        child: Text(
                          'at',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                      ),

                      // === select Time ===
                      RaisedButton(
                        child: Text('4:15 PM'),
                        color: Colors.blue[100],
                        onPressed: () async {
                          TimeOfDay pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              selectedDated = DateTime(
                                selectedDated.year,
                                selectedDated.month,
                                selectedDated.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                          }
                        },
                      ),
                    ],
                  ),

                  //=== title (what is the price?) ===
                  BottomSheetItemTitle('What\'s the price? '),
                  //=== input add price ===
                  Card(
                    color: Colors.blue[100],
                    elevation: 5,
                    child: TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        border: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                      ),
                    ),
                  ),

                  //=== button add order ===
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          'Add order',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          try {
                            double price = double.parse(priceController.text);
                            if (price < 0) {
                              throw 'Invalid price';
                            }

                            // === key + Order ===
                            String key =
                                DateFormat('yyyyMMdd').format(selectedDated);
                            Order order = Order(
                              deliveryMan: selectedDeliveryMan,
                              price: price,
                              orderDate: selectedDated,
                            );
                            widget.addOrder(key,order);
                          } catch (error) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Invalid price'),
                                  content: Text('Please enter valid price.'),
                                  actions: [
                                    FlatButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
