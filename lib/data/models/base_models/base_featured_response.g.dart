// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_featured_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseFeaturedResponse _$BaseFeaturedResponseFromJson(
  Map<String, dynamic> json,
) =>
    BaseFeaturedResponse(
      id: json['ID'] as int?,
      title: json['title'] as String?,
      price: json['price'] as String?,
      discountPrice: json['discountPrice'] as String?,
      sold: json['sold'] as bool?,
      img: json['img'] as String?,
      videoCount: json['car_videos_count'] as int?,
    );

Map<String, dynamic> _$BaseFeaturedResponseToJson(
  BaseFeaturedResponse instance,
) =>
    <String, dynamic>{
      'ID': instance.id,
      'title': instance.title,
      'price': instance.price,
      'discountPrice': instance.discountPrice,
      'sold': instance.sold,
      'img': instance.img,
      'car_videos_count': instance.videoCount,
    };
