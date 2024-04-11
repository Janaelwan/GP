import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled14/Cubit/States.dart';
import 'package:untitled14/Cubit/cubit.dart';

import 'Home Screen.dart';
import 'Register.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
          body: SafeArea(
            child: Form(
              key: formKey,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.asset(
                      "lib/assets/16544.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "this field is required";
                            }
                            return null;
                          },
                          controller: cubit.emailLogin,
                          decoration: InputDecoration(
                            hintText: "e-mail",
                            focusColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "this field is required";
                            }
                            return null;
                          },
                          obscureText: cubit.isShowed ? true : false,
                          controller: cubit.passwordLogin,
                          decoration: InputDecoration(
                            hintText: "password",
                            suffixIcon: IconButton(
                              icon: Icon(cubit.isShowed
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                if (cubit.isShowed == true) {
                                  cubit.isShowed = false;
                                  cubit.showPassword(cubit.isShowed);
                                } else {
                                  cubit.isShowed = true;
                                  cubit.showPassword(cubit.isShowed);
                                }
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                bool isLoginSuccessful = await cubit.authenticateUser(
                                  cubit.emailLogin.text,
                                  cubit.passwordLogin.text,
                                  context,
                                );

                                if (isLoginSuccessful) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Incorrect email or password'),
                                      duration: Duration(seconds: 4),
                                    ),
                                  );
                                }
                              }
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Do not have an account?",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Register(),
                                  ),
                                );
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
