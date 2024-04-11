import 'dart:async';

import 'package:flutter/material.dart';
import 'package:untitled14/Screens/Home%20Screen.dart';
import 'package:untitled14/Screens/Register.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Register()));
    });
    return Scaffold(
        body: Stack(alignment: Alignment.bottomCenter,
          children: [
            Image.network(
                  "https://static.vecteezy.com/system/resources/previews/002/073/512/non_2x/woman-using-a-smartphone-with-technology-icons-in-the-background-free-photo.jpg",
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8,0,8,30),
              child: Text ("Welcome To E-commerace Application",style:TextStyle(fontSize: 27,color: Colors.white,fontWeight: FontWeight.bold)),
            )
          ],
        ));
  }
}
