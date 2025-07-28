// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_page_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MainPageResponse _$MainPageResponseFromJson(Map<String, dynamic> json) => MainPageResponse(
      featured: (json['featured'] as List<dynamic>).map((e) => BaseFeaturedResponse.fromJson(e as Map<String, dynamic>)).toList(),
      recent: (json['recent'] as List<dynamic>?)
          ?.map(
            (e) => BaseCarDetailResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      viewType: json['viewType'] as String,
      offset: json['offset'] as String?,
      limit: json['limit'] as String?,
      featuredMaxNumPages: json['featured_max_num_pages'] as int?,
      lastMaxNumPages: json['last_max_num_pages'] as int?,
    );

Map<String, dynamic> _$MainPageResponseToJson(MainPageResponse instance) => <String, dynamic>{
      'featured': instance.featured,
      'recent': instance.recent,
      'viewType': instance.viewType,
      'offset': instance.offset,
      'limit': instance.limit,
      'featured_max_num_pages': instance.featuredMaxNumPages,
      'last_max_num_pages': instance.lastMaxNumPages,
    };
