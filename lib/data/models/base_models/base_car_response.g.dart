// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_car_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseCarDetailResponse _$BaseCarDetailResponseFromJson(
  Map<String, dynamic> json,
) =>
    BaseCarDetailResponse(
      key: json['key'] as int?,
      ID: json['ID'] as int,
      imgUrl: json['imgUrl'] as String?,
      gallery: (json['gallery'] as List<dynamic>?)
          ?.map(
            (e) => e == null ? null : GalleryAuto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      imgCount: json['imgCount'] as int?,
      price: json['price'] as String?,
      discountPrice: json['discountPrice'] as String?,
      sold: json['sold'] as bool?,
      videoCount: json['car_videos_count'] as int?,
      grid: json['grid'] == null ? null : Grid.fromJson(json['grid'] as Map<String, dynamic>),
      list: ListFav.fromJson(json['list'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BaseCarDetailResponseToJson(
  BaseCarDetailResponse instance,
) =>
    <String, dynamic>{
      'key': instance.key,
      'ID': instance.ID,
      'imgUrl': instance.imgUrl,
      'gallery': instance.gallery,
      'imgCount': instance.imgCount,
      'price': instance.price,
      'discountPrice': instance.discountPrice,
      'sold': instance.sold,
      'car_videos_count': instance.videoCount,
      'grid': instance.grid,
      'list': instance.list,
    };

GalleryAuto _$GalleryAutoFromJson(Map<String, dynamic> json) => GalleryAuto(
      url: json['url'] as String?,
    );

Map<String, dynamic> _$GalleryAutoToJson(GalleryAuto instance) => <String, dynamic>{
      'url': instance.url,
    };

Grid _$GridFromJson(Map<String, dynamic> json) => Grid(
      title: json['title'] as String?,
      subTitle: json['subTitle'] as String?,
      infoIcon: json['infoIcon'] as String?,
      infoTitle: json['infoTitle'] as String?,
      infoDesc: json['infoDesc'] as String?,
    );

Map<String, dynamic> _$GridToJson(Grid instance) => <String, dynamic>{
      'title': instance.title,
      'subTitle': instance.subTitle,
      'infoIcon': instance.infoIcon,
      'infoTitle': instance.infoTitle,
      'infoDesc': instance.infoDesc,
    };

ListFav _$ListFavFromJson(Map<String, dynamic> json) => ListFav(
      title: json['title'] as String?,
      infoOneIcon: json['infoOneIcon'] as String?,
      infoOneTitle: json['infoOneTitle'] as String?,
      infoOneDesc: json['infoOneDesc'] as String?,
      infoTwoIcon: json['infoTwoIcon'] as String?,
      infoTwoTitle: json['infoTwoTitle'] as String?,
      infoTwoDesc: json['infoTwoDesc'] as String?,
      infoThreeIcon: json['infoThreeIcon'] as String?,
      infoThreeTitle: json['infoThreeTitle'] as String?,
      infoThreeDesc: json['infoThreeDesc'] as String?,
      infoFourIcon: json['infoFourIcon'] as String?,
      infoFourTitle: json['infoFourTitle'] as String?,
      infoFourDesc: json['infoFourDesc'] as String?,
    );

Map<String, dynamic> _$ListFavToJson(ListFav instance) => <String, dynamic>{
      'title': instance.title,
      'infoOneIcon': instance.infoOneIcon,
      'infoOneTitle': instance.infoOneTitle,
      'infoOneDesc': instance.infoOneDesc,
      'infoTwoIcon': instance.infoTwoIcon,
      'infoTwoTitle': instance.infoTwoTitle,
      'infoTwoDesc': instance.infoTwoDesc,
      'infoThreeIcon': instance.infoThreeIcon,
      'infoThreeTitle': instance.infoThreeTitle,
      'infoThreeDesc': instance.infoThreeDesc,
      'infoFourIcon': instance.infoFourIcon,
      'infoFourTitle': instance.infoFourTitle,
      'infoFourDesc': instance.infoFourDesc,
    };
