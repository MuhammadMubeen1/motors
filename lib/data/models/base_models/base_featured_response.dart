import 'package:json_annotation/json_annotation.dart';

part 'base_featured_response.g.dart';

/*
 {
  "ID": 5300,
  "title": "Mazda 2 1.2 Hatchback 79.000miles",
  "price": "2.999€",
  "discountPrice": "$22 000",
  "sold": false,
  "img": "https://cars.com.mt/wp-content/uploads/2022/08/IMG_3121-690x410.jpg"
  "car_videos_count": 0
 },
*/

@JsonSerializable()
class BaseFeaturedResponse {
  BaseFeaturedResponse({
    required this.id,
    required this.title,
    required this.price,
    required this.discountPrice,
    required this.sold,
    required this.img,
    required this.videoCount,
  });

  factory BaseFeaturedResponse.fromJson(Map<String, dynamic> json) => _$BaseFeaturedResponseFromJson(json);

  @JsonKey(name: 'ID')
  final int? id;
  final String? title;
  final String? price;
  final String? discountPrice;
  final bool? sold;
  final String? img;
  @JsonKey(name: 'car_videos_count')
  final int? videoCount;

  Map<String, dynamic> toJson() => _$BaseFeaturedResponseToJson(this);
}
