import 'package:flutter/material.dart';

import '../Cubit/cubit.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    final cubit = AppCubit.get(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(
                  child: Text(
                    "Orders",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 30),
                FutureBuilder<List<Map>>(
                  future: cubit.getOrdersFromDatabaase(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<Map>? allOrders = snapshot.data;
                      // Filter orders for the logged-in user
                      List<Map> userOrders = allOrders!
                          .where(
                              (order) => order["userId"] == cubit.loggedUserId)
                          .toList();

                      return userOrders.isEmpty
                          ? Center(child: Text("No orders found"))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var order in userOrders)
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Product ${order["productName"]}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Quantity: ${order["quantity"]}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Price: ${order["totalPrice"]}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                              title: Text(
                                                                  "Delete Order"),
                                                              content: Text(
                                                                "Are you sure you want to delete this order?",
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () {
                                                                    Navigator
                                                                        .pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      "Cancel"),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () {
                                                                    // Call the deleteOrder method
                                                                    cubit
                                                                        .deleteFromOrders(
                                                                        order["id"]);
                                                                    Navigator
                                                                        .pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      "Delete"),
                                                                ),
                                                              ]
                                                          );
                                                        }
                                                    );
                                                  },

                                                  icon: Icon(Icons.delete)
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                SizedBox(
                                  height: 16, // Add some spacing between orders
                                ),

                              ],
                            );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
