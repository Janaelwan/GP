class ProductModel {
  final int id;
  final String title;
  final dynamic price;
  final String description;
  final String category;
  final String image;
  final Rating rating;
final countProduct;
  ProductModel({required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  required this.countProduct
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        id: json['id'],
        title: json['title'],
        price: json['price'],
        description: json['description'],
        category: json['category'],
        image: json['image'],
        rating: Rating(
            rate: json['rating']['rate'],
            count: json['rating']['count']
        ), countProduct: null
    )
    ;
  }

  String toString() {
    return 'ProductModel{name: $title, price: $price,image:$image}';
  }
}

class Rating {
   var rate;
  final int count;

  Rating({required this.rate, required this.count});

}


