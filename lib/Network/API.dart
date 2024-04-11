import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;
import 'package:untitled14/Constants/const.dart';
import 'package:untitled14/Model/ProductModel.dart';
class API {
  Future<List<ProductModel>> getProducts(BuildContext context) async {
    var url = Uri.parse(productEndPoint);
    var response = await http.get(url);
    final data = jsonDecode(response.body);
    return data.map<ProductModel>((e)=>ProductModel.fromJson(e)).toList();
  }
  Future<List<String>> getCategory(BuildContext context) async {
    var url = Uri.parse(category);
    var response = await http.get(url);
    final data = jsonDecode(response.body);
    return data.map<String>((e)=>e.toString()).toList();
  }
  Future<List<ProductModel>>  getProductByCategory(BuildContext context,categoryName) async {
    String productByCategoryURL="https://fakestoreapi.com/products/category/$categoryName";
    var url = Uri.parse(productByCategoryURL);
    var response = await http.get(url);
    final data = jsonDecode(response.body);
    return data.map<ProductModel>((e)=>ProductModel.fromJson(e)).toList();
  }

  Future<void> makePrediction(List<List<double>> inputData) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/predict'),  // Replace with Ngrok URL if used
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'input': inputData}),
    );

    if (response.statusCode == 200) {
      final prediction = jsonDecode(response.body)['prediction'];
      print('Prediction result: $prediction');
      // Handle the prediction result in your Flutter app as needed
    } else {
      print('Failed to make prediction: ${response.statusCode}');
      // Handle error in your Flutter app
    }
  }

}