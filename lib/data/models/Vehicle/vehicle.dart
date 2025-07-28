class Vehicle {
  final int id;
  final String imageUrl;
  final List<String> gallery;
  final String price;
  final String title;
  final String subTitle;
  final String mileage;
  final String bodyType;
  final String fuelType;

  Vehicle({
    required this.id,
    required this.imageUrl,
    required this.gallery,
    required this.price,
    required this.title,
    required this.subTitle,
    required this.mileage,
    required this.bodyType,
    required this.fuelType,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['ID'],
      imageUrl: json['imgUrl'],
      gallery: List<String>.from(json['gallery'].map((x) => x['url'])),
      price: json['price'],
      title: json['grid']['title'],
      subTitle: json['grid']['subTitle'],
      mileage: json['list']['infoOneDesc'],
      bodyType: json['list']['infoTwoDesc'],
      fuelType: json['list']['infoThreeDesc'],
    );
  }
}
