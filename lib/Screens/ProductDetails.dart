import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:untitled14/Cubit/cubit.dart';
import 'package:untitled14/Screens/CardScreen.dart';

import '../Cubit/States.dart';
import '../Model/ProductModel.dart';
import '../Network/API.dart';

class ProductDetails extends StatefulWidget {
  ProductDetails(this.product);

  final ProductModel product;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(builder: (context, state) {
      AppCubit cubit = AppCubit.get(context);
      return Scaffold(
          appBar: AppBar(
              leading: IconButton(
            icon: Icon(Icons.shop),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CardScreen()));
            },
          )),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Expanded(
                    child: Image.network(widget.product.image,
                        width: double.infinity)),
                SizedBox(height: 40),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.product.title,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis),
                        Text(
                          "${widget.product.price}\$",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          maxLines: 1,
                        ),
                        Text(
                          widget.product.description,
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RatingBar.builder(
                              initialRating:
                                  widget.product.rating.rate.runtimeType ==
                                          double
                                      ? widget.product.rating.rate
                                      : widget.product.rating.rate.toDouble(),
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black)),
                              onPressed: () {

                                  if (cubit.productsCard.contains(widget.product)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                            Text(
                                                'This product already added check your card'),
                                            duration: Duration(seconds: 4)));
                                  }

                                  else {
                                    cubit.addProductToCard(widget.product);
                                    setState(() {
                                 cubit.count.add(1);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                            Text('product is added to card'),
                                            duration: Duration(seconds: 4)));

                                    print(cubit.productsCard);
                                  }
                                },


                              child: Text(
                                "Add to card",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: Colors.white),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ));
    });
  }
}

API api = new API();
