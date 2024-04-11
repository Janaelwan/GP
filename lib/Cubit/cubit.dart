import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled14/Cubit/States.dart';
import 'package:bcrypt/bcrypt.dart';
import '../Model/ProductModel.dart';
import '../Screens/Chat.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(initialState()) {
    // Initialize the database in the constructor
    createDatabase();
  }
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController emailRegister = TextEditingController();
  TextEditingController passwordRegister = TextEditingController();
  TextEditingController phone_number = TextEditingController();
  TextEditingController emailLogin = TextEditingController();
  TextEditingController passwordLogin = TextEditingController();
  TextEditingController creditCardController = TextEditingController();
  List<ProductModel> productsCard = [];
  List<ProductModel> order = [];
  String paymentMethod = "";
  List<int> count = [];
  int loggedUserId = -1;
  double totalPrice = 0.0;

  void addProductToCard(ProductModel product) {
    productsCard.add(product);
    totalPrice += product.price;

    emit(ProductsAddedToCard());
  }

  bool isShowed = true;

  void showPassword(bool x) {
    isShowed = x;
    emit(ShowPasswordState());
  }

  static AppCubit get(context) => BlocProvider.of(context);
  late Database databas;

  Widget showTextField() {
    if (paymentMethod == "Visa") {
      return TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "This field is required";
          }
          if (value.length != 16) {
            return "invalid credit card number";
          }
          return null;
        },
        controller: creditCardController,
        decoration: InputDecoration(hintText: "Credit card Number"),
      );
    }
    return Text("");
  }


  Future<List<Map<String, dynamic>>> getMessages() async {
    final List<Map<String, dynamic>> messages = await databas.rawQuery(
      'SELECT text FROM messages',
    );

    return messages;
  }
  createDatabase() async{
    databas = await
    openDatabase(
      'e-commerce.db',
      version: 4,
      onCreate: (db, version) async {
        print("Database Created");
        await db
            .execute(
                "Create Table users (id INTEGER PRIMARY KEY,name TEXT,phoneNumber TEXT ,email TEXT,password TEXT,address TEXT)")
            .then((value) {
          print("Table created");
        }).catchError((onError) {
          print("Catched Error is ${onError.toString()}");
        });
        await db
            .execute(
            'CREATE TABLE messages(id INTEGER PRIMARY KEY,CustomerId INTEGER, text TEXT, type TEXT,FOREIGN KEY (CustomerId) REFERENCES users(id))')
            .then((value) {
          print("Messages Table created");
        }).catchError((onError) {
          print("Catched Error is ${onError.toString()}");
        });
        await db
            .execute(
                "CREATE TABLE orders (id INTEGER PRIMARY KEY, userId INTEGER, productName TEXT, quantity INTEGER, totalPrice REAL,creditCardNumber ,FOREIGN KEY (userId) REFERENCES users(id))")
            .then((value) {
          print("Orders Table created");
        }).catchError((onError) {
          print("Catched Error is ${onError.toString()}");
        });
      },
      onOpen: (db) {
        print("Database Opened");
      },
    );
    emit(CreateDataProfile());
  }
  Future<List<Map<String, dynamic>>> getMessagesForUser(int userId) async {
    final List<Map<String, dynamic>> messages = await databas.rawQuery(
      'SELECT * FROM messages WHERE CustomerId = ?',
      [userId],
    );

    return messages;
  }
  Future<List<Map<String, dynamic>>> getAllMessages() async {
    final List<Map<String, dynamic>> messages = await databas.rawQuery(
      'SELECT * FROM messages'
    );

    return messages;
  }
  void insertMessage(String text, String type,int logged) async {
    await databas.transaction((txn) async {
      await txn.rawInsert(
        'INSERT INTO messages(text, type,CustomerID) VALUES("$text", "$type",$logged)',
      );
      print("raw insert msg");
      getMessagesForUser(1);
    });

    emit(MessageInserted());
  }

  int failedLoginAttempts = 0;
  static const int maxLoginAttempts = 3;
  int lastFailedAttempt = 0;
  int blockingDuration = 60; // in seconds
  int remainingTime = 0;
  late Timer blockingTimer;

  Future<bool> authenticateUser(String email, String password, BuildContext context) async {
    final profileData = await getProfileFromDatabaase();

    // Check if the user is temporarily blocked
    if (failedLoginAttempts >= maxLoginAttempts) {
      int elapsedSeconds = ((DateTime.now().millisecondsSinceEpoch - lastFailedAttempt) ~/ 1000);
      remainingTime = max(0, (blockingDuration - elapsedSeconds));
      if (remainingTime > 0) {
        // Less than blockingDuration seconds have passed since the last failed attempt
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Too Many Failed Attempts'),
            content: Column(
              children: [
                Text('You have exceeded the maximum number of login attempts.'),
                SizedBox(height: 10),
                Text('Please wait for $remainingTime seconds before trying again.'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );

        return false;
      }
    }

    bool isUserValid = false;

    for (int i = 0; i < profileData.length; i++) {
      if (email == profileData[i]["email"] && BCrypt.checkpw(password, profileData[i]["password"])) {
        // Reset failed attempts upon successful login
        failedLoginAttempts = 0;
        loggedUserId = profileData[i]["id"];
        isUserValid = true;
        break;
      }
    }

    // Increment failed attempts if user is not valid
    if (!isUserValid) {
      failedLoginAttempts++;
      lastFailedAttempt = DateTime.now().millisecondsSinceEpoch;

      if (failedLoginAttempts >= maxLoginAttempts) {
        // Show a dialog and return false to prevent further login attempts
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Too Many Failed Attempts'),
            content: Column(
              children: [
                Text('You have exceeded the maximum number of login attempts.'),
                SizedBox(height: 10),
                Text('The app will now exit.'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Close the app
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: Text('OK'),
              ),
            ],
          ),
        );

        return false;
      }
    }

    return isUserValid;
  }




  void insertIntoDatabase(String name, String phoneNumber, String email,
      String password, String address) async {
    String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

    await databas.transaction((txn) async {
      txn
          .rawInsert(
              'Insert into users (name,phoneNumber,email,password,address) VALUES ("$name","$phoneNumber","$email","$hashedPassword","$address")')
          .then((value) {
        print("$value raw inserted");
      }).catchError((e) {
        print(e);
      });
    });
    Future<int?> authenticateUser(String email, String password) async {
      // Your authentication logic here, which could involve an API call or database lookup
      // Return the user ID if authentication is successful, or null otherwise
      // For demonstration purposes, let's return a hardcoded user ID (1) for successful login
      return 1;
    }

    getProfileFromDatabaase();
    emit(InsertinProfile());
  }

  void insertInOrders(String productName, int quantity, double price,
      int userID, String creditCard) async {
    await databas.transaction((txn) async {
      txn
          .rawInsert(
              'Insert into orders (userId, productName, quantity, totalPrice,creditCardNumber) VALUES ($userID, "$productName", $quantity, $price,$creditCard)')
          .then((value) {
        print("$value raw inserted");
      }).catchError((e) {
        print(e);
      });
    });
    getOrdersFromDatabaase();
    emit(InsertInOrders());
  }

  Future<int?> getUserIdByEmail(String email) async {
    // Ensure that the databaseProfile is initialized before using it
    if (databas == null) {
      await createDatabase(); // Initialize the databaseProfile
    }

    // Fetch user data from the database
    final data =
        await databas.rawQuery("SELECT id FROM users WHERE email=?", [email]);

    if (data.isNotEmpty) {
      return data.first['id'] as int?; // Return the user ID as an int
    } else {
      return null; // Return null if no user is found with the given email
    }
  }

  void deleteFromOrders(int id) async {
    await databas.rawDelete('Delete from orders WHERE id=?', [id]).then(
        (value) => print("raw deleted"));
    getOrdersFromDatabaase();
    emit(DeleteFromOrders());
  }

  List<Map> orders = [];

  Future<List<Map>> getOrdersFromDatabaase() async {
    // Ensure that the databaseProfile is initialized before using it
    if (databas == null) {
      await createDatabase(); // Initialize the databaseProfile
    }

    // Fetch data from the database
    final data = await databas.rawQuery("Select * from orders");
    orders = data;
    // print(orders);
    emit(getFromOrders());
    return orders;
  }

  List<Map> datalogin = [];

  Future<List<Map>> getProfileFromDatabaase() async {
    // Ensure that the databaseProfile is initialized before using it
    if (databas == null) {
      await createDatabase(); // Initialize the databaseProfile
    }

    // Fetch data from the database
    final data = await databas.rawQuery("Select * from users");
    datalogin = data;
    print(datalogin);
    emit(getFromDataProfile());
    return datalogin;
  }

  void deleteFromDatabase(int id) async {
    await databas.rawDelete('Delete from users WHERE id=?', [id]).then(
        (value) => print("raw deleted"));
    getFromDataProfile();
    emit(DeleteFromUsersDatabase());
  }
  Widget FlaotButton (BuildContext context){
    return FloatingActionButton(backgroundColor: Colors.black,onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Chat()));
    },child:Icon(Icons.question_mark_sharp),);
  }
}
