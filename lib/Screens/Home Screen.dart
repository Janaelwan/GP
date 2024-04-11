import 'package:flutter/material.dart';
import 'package:untitled14/Model/ProductModel.dart';
import 'package:untitled14/Network/API.dart';
import 'package:untitled14/Screens/CardScreen.dart';
import 'package:untitled14/Screens/ProductDetails.dart';

import 'order.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  API api = new API();
  late Future<List<ProductModel>> productFuture;
  late Future<List<String>> categoryFuture;
  bool isSearch = false;
  List<ProductModel> searchProductList = [];
  List<ProductModel> productList = [];
  String searchWord = "";
  int _selectedIndex = 0;

  TextEditingController search = new TextEditingController();
  FocusNode focusNode1 = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productFuture = api.getProducts(context);
    categoryFuture = api.getCategory(context);
  }

  Widget listSearch() {
    focusNode1.requestFocus();
    search.value = TextEditingValue(
        text: searchWord,
        selection: TextSelection.collapsed(offset: searchWord.length));
    return SafeArea(
      child: FutureBuilder<List>(
          future: Future.wait([productFuture, categoryFuture]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data == null) {
              return Center(child: Text("No data"));
            }

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                          focusNode: focusNode1,
                          controller: search,
                          decoration: InputDecoration(
                            hintText: "Search for product",
                            suffixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onChanged: (value) {
                            if (value.isEmpty) {
                              isSearch = false;
                              setState(() {});
                            }
                            searchWord = value;
                            searchProductList = productList
                                .where((product) =>
                                    product.title.toLowerCase().contains(value))
                                .toList();
                            setState(() {});
                          }),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        onPressed: () => show(context, snapshot.data![1]),
                        icon: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Icon(
                              Icons.filter_list,
                            )))
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.8),
                      itemBuilder: (context, index) {
                        final product = searchProductList[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetails(product)));
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Image.network(
                                        product.image,
                                        height: 100,
                                        width: 100,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      product.title,
                                      maxLines: 2,
                                    ),
                                    Text(
                                      "${product.price}\$",
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: searchProductList.length),
                ),
              ],
            );
          }),
    );
  }

  Widget listProduct() {
    return SafeArea(
      child: FutureBuilder<List>(
          future: Future.wait([productFuture, categoryFuture]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data == null) {
              return Center(child: Text("No data"));
            }
            productList = snapshot.data![0];
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search for product",
                          suffixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            isSearch = false;
                            setState(() {});
                          }
                          if (value.isNotEmpty) {
                            searchWord = value;
                            isSearch = true;

                            setState(() {});
                          }

                          searchProductList = productList
                              .where((product) =>
                                  product.title.toLowerCase().contains(value))
                              .toList();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        onPressed: () => show(context, snapshot.data![1]),
                        icon: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Icon(
                              Icons.filter_list,
                            )))
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.8),
                      itemBuilder: (context, index) {
                        final product = snapshot.data![0][index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetails(product)));
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Image.network(
                                        product.image,
                                        height: 100,
                                        width: 100,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      product.title,
                                      maxLines: 2,
                                    ),
                                    Text(
                                      "${product.price}\$",
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: productList.length),
                ),
              ],
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0
          ? (isSearch ? listSearch() : listProduct())
          : listProduct(),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: IconButton(icon:Icon(Icons.home),onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },),
            label: 'Home',

          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CardScreen()));
              },
            ),
            label: 'Card',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.payment),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OrderScreen()));
              },
            ),
            label: 'Payment',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void show(BuildContext con, List<String> listOfCategory) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  productFuture =
                      api.getProductByCategory(context, listOfCategory[index]);
                  setState(() {});
                },
                leading: Icon(Icons.category),
                title: Text(listOfCategory[index]),
              );
            },
            itemCount: listOfCategory.length,
          ),
        );
      },
    );
  }
}
