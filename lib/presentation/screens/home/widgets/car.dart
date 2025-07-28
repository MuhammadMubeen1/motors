class Car {
  final String id;
  final String imgUrl;
  final List<dynamic> gallery;
  final int imgCount;
  final String price;
  final Map<String, dynamic> grid;
  final Map<String, dynamic> list;

  Car({
    required this.id,
    required this.imgUrl,
    required this.gallery,
    required this.imgCount,
    required this.price,
    required this.grid,
    required this.list,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['ID'].toString(),
      imgUrl: json['imgUrl'] ?? '',
      gallery: json['gallery'] ?? [],
      imgCount: json['imgCount'] ?? 0,
      price: json['price'] ?? 'No Price',
      grid: json['grid'] ?? {},
      list: json['list'] ?? {},
    );
  }
}
