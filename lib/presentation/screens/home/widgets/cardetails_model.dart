// car_listing_model.dart
class CarListing {
  final String id;
  final String imageUrl;
  final List<String> gallery;
  final String price;
  final String title;
  final String subTitle;
  final String mileage;
  final String bodyType;
  final String fuelType;

  CarListing({
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

  factory CarListing.fromJson(Map<String, dynamic> json) {
    return CarListing(
      id: json['ID'].toString(),
      imageUrl: json['imgUrl'] ?? '',
      gallery: (json['gallery'] as List<dynamic>?)
              ?.map((item) => item['url'] as String)
              ?.toList() ??
          [],
      price: json['price'] ?? 'Price not available',
      title: json['grid']['title'] ?? 'No title',
      subTitle: json['grid']['subTitle'] ?? '',
      mileage: json['list']['infoOneDesc'] ?? 'N/A',
      bodyType: json['list']['infoTwoDesc'] ?? 'N/A',
      fuelType: json['list']['infoThreeDesc'] ?? 'N/A',
    );
  }
}
