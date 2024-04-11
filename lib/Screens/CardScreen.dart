import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Cubit/States.dart';
import '../Cubit/cubit.dart';
import 'Chat.dart';
import 'Confirm Paying.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  @override
  Widget build(BuildContext context) {
    final cubit = AppCubit.get(context);
    final products = cubit.productsCard;
    print('Products in CardScreen: $products');
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Screen'),
      ),
      body: products.isEmpty?Center(child: Text("No Products in the card")):Column(
        children: [
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 10,
                );
              },
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          child: Image.network("${products[index].image}"),
                        ),
                        Column(
                          children: [
                            Text(
                              "${products[index].title}",
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("${products[index].price}\$"),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                FloatingActionButton(
                                  heroTag: "plus$index",
                                  backgroundColor: Colors.black,
                                  onPressed: () {
                                    setState(() {
                                      cubit.count[index]++;
                                      cubit.totalPrice += products[index].price;
                                    });
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text("${cubit.count[index]}"),
                                SizedBox(
                                  width: 7,
                                ),
                                FloatingActionButton(
                                  heroTag: "minus$index",
                                  backgroundColor: Colors.black,
                                  onPressed: () {
                                    if (cubit.count[index] > 0) {
                                      setState(() {
                                        cubit.count[index]--;
                                        if (cubit.count[index] == 0) {
                                          cubit.totalPrice -=
                                              products[index].price;
                                          products.removeAt(index);
                                        } else {
                                          cubit.totalPrice -=
                                              products[index].price;
                                        }
                                        if (products.isEmpty) {
                                          cubit.totalPrice = 0.0;
                                        }
                                      });
                                    }
                                  },
                                  child: Icon(
                                    Icons.minimize,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      cubit.totalPrice -= products[index].price;
                                      products.removeAt(index);
                                      if (products.isEmpty) {
                                        cubit.totalPrice = 0.0;
                                      }
                                    });
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Text(
                        "The total price is: ",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${cubit.totalPrice.toStringAsFixed(2)}\$",
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ConfirmPaying()));
                    cubit.getOrdersFromDatabaase();
                      },

                    child: Text(
                      "Continue paying",
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

        ],
      ),
floatingActionButton: FloatingActionButton(backgroundColor: Colors.black,onPressed: () {
  Navigator.push(context, MaterialPageRoute(builder: (context)=>Chat()));
},child:Icon(Icons.question_mark_sharp),)
    );
  }
}
