import 'package:avoid_keyboard/avoid_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled14/Cubit/States.dart';
import 'package:untitled14/Cubit/cubit.dart';
import 'package:untitled14/Screens/Home%20Screen.dart';
import 'package:untitled14/Screens/Login.dart';

class Register extends StatelessWidget {
  Register({super.key});

  RegExp specialCharRegExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  RegExp uppercaseRegExp = RegExp(r'[A-Z]');

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(builder: (context, state) {
      AppCubit cubit = AppCubit.get(context);
      return Scaffold(
        body: SafeArea(
          child: Form(
            key: formKey,
            child: Stack(
              children: [
                Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: Image.asset(
                      "lib/assets/16544.jpg",
                      fit: BoxFit.cover,
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                            child: Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "this field is required";
                            }
                            return null;
                          },
                          controller: cubit.name,
                          decoration: InputDecoration(
                              hintText: "Name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "this field is required";
                            }
                            return null;
                          },
                          controller: cubit.address,
                          decoration: InputDecoration(
                              hintText: "address",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "this field is required";
                            }
                            if (value.length != 11) {
                              return "invalid mobile number";
                            }
                            return null;
                          },
                          controller: cubit.phone_number,
                          decoration: InputDecoration(
                              hintText: "Phone number",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: cubit.emailRegister,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "this field is required";
                            }
                            if (!value.contains("@")) {
                              return "Invalid email format";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: "e-mail",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "this field is required";
                            }
                            if (value.length < 7 ||
                                !specialCharRegExp.hasMatch(value) ||
                                !uppercaseRegExp.hasMatch(value)) {
                              return "At least one special character and uppercase";
                            }
                            return null;
                          },
                          obscureText: cubit.isShowed ? true : false,
                          controller: cubit.passwordRegister,
                          decoration: InputDecoration(
                              hintText: "password",
                              suffixIcon: IconButton(
                                icon: Icon(cubit.isShowed?Icons.visibility:Icons.visibility_off),
                                onPressed: () {
                                  if(cubit.isShowed==true){
                                    cubit.isShowed=false;
                                    cubit.showPassword(cubit.isShowed);
                                  }
                                  else{
                                    cubit.isShowed=true;
                                    cubit.showPassword(cubit.isShowed);
                                  }
                                },
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(width: double.infinity,height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          child: ElevatedButton(
                              child: Text(
                                "Regiter",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black)),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  final profileData =
                                      await cubit.getProfileFromDatabaase();
                                  bool emailExists = false;
                              
                                  for (int i = 0; i < profileData.length; i++) {
                                    if (profileData[i]['email'] ==
                                        cubit.emailRegister.text) {
                                      emailExists = true;
                                      break;
                                    }
                                  }
                              
                                  if (!emailExists) {
                                    // Insert the new user's data into the database
                                    cubit.insertIntoDatabase(
                                      cubit.name.text,
                                      cubit.phone_number.text,
                                      cubit.emailRegister.text,
                                      cubit.passwordRegister.text,
                                      cubit.address.text,
                                    );

                                    cubit.loggedUserId = (await cubit.getUserIdByEmail(cubit.emailRegister.text))!;


                                    // Navigate to the HomeScreen after registration
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen()),
                                    );
                                  } else {
                                    // Handle case where email already exists (you might want to show an error message)
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'this e-mail is already exsit'),
                                            duration: Duration(seconds: 4)));
                                  }
                                }
                              }),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("already have account?",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                            TextButton(
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()));
                                },
                                child: Text("Login",style: TextStyle(color: Colors.black),))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
