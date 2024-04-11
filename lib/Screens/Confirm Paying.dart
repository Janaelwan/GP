import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:untitled14/Constants/const.dart';
import '../Cubit/cubit.dart';
import 'package:http/http.dart' as http;

class ConfirmPaying extends StatefulWidget {
  const ConfirmPaying({Key? key});

  @override
  State<ConfirmPaying> createState() => _ConfirmPayingState();
}

class _ConfirmPayingState extends State<ConfirmPaying> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubit = AppCubit.get(context);
    String? useADD;
    String? useEm;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Order Confirmation",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 30),
                  FutureBuilder<List<Map>>(
                    future: cubit.getProfileFromDatabaase(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<Map>? userInfo = snapshot.data;
                        // Filter orders for the logged-in user
                        List<Map> loggedUser = userInfo!
                            .where((user) => user["id"] == cubit.loggedUserId)
                            .toList();

                        if (loggedUser.isEmpty) {
                          // Handle case where user data is not found
                          return Text(
                              'User information not found for the logged-in user.');
                        }
                        useADD = loggedUser[0]["address"];
                        useEm = loggedUser[0]["email"];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Your address is: ${loggedUser[0]["address"]}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Your name to the order: ${loggedUser[0]["name"]}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Your email to the order: ${loggedUser[0]["email"]}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  Text(
                    "Select Your payment method",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                  RadioListTile(
                    title: Text('Cash'),
                    value: 'Cash',
                    groupValue: cubit.paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        cubit.paymentMethod = value as String;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('Visa'),
                    value: 'Visa',
                    groupValue: cubit.paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        cubit.paymentMethod = value as String;
                      });
                    },
                  ),
                  cubit.showTextField(),
                  SizedBox(height: 15),
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                         /* final userInput = {
                            "TransactionAMT": 0.0,
                            "ProductCD": "",
                            "card1": 0,
                            "Device Type": "",
                            "Purchaser Email Domain": "",
                            "Address": ""
                            // Add more features based on your model requirements...
                          };

                          for (int i = 0; i < cubit.productsCard.length; i++) {
                            userInput["TransactionAMT"] =
                                cubit.productsCard[i].price;
                            userInput["ProductCD"] = cubit.productsCard[i].id;
                            userInput["Device Type"] =
                                cubit.productsCard[i].title;
                          }

                          userInput["card1"] = cubit.creditCardController.text;
                          userInput["Purchaser Email Domain"] = useEm as Object;
                          userInput["Address"] = useADD as Object;

                          try {
                            // Show loading indicator
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return Center(
                                    child: CircularProgressIndicator());
                              },
                            );
                            final response = await http.post(
                              Uri.parse("https://ca37-35-230-43-70.ngrok-free.app/predict"),
                              headers: {
                                'Content-Type': 'application/json',
                                'ngrok-skip-browser-warning': 'true',
                                'User-Agent': 'Your-Custom-User-Agent',
                              },
                              body: jsonEncode({
                                'input': [userInput]
                              }),
                            );


                            // Close loading indicator
                            Navigator.of(context).pop();

                            if (response.statusCode == 200) {
                              final prediction =
                                  jsonDecode(response.body)['predictions'];
                              print('Prediction result: $prediction');
*/
                              // Handle the prediction result as needed
                              for (int i = 0;
                                  i < cubit.productsCard.length;
                                  i++) {
                                cubit.insertInOrders(
                                  "${cubit.productsCard[i].title}",
                                  cubit.count[i],
                                  cubit.productsCard[i].price,
                                  cubit.loggedUserId,
                                  cubit.creditCardController.text,
                                );
                              }

                              cubit.productsCard.clear();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Order confirmed"),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }/* else {
                              // Show error message
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Order Failed!"),
                                    content: Text(
                                        "Your order confirmation failed${response.statusCode}"),
                                  );
                                },
                              );
                            }
                          } catch (e) {
                            // Handle exceptions
                            print('Error during the request: $e');
                          }
                        }*/
                      },
                      child: Text(
                        "Confirm order",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 27,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
