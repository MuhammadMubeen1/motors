// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_result_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterResultResponse _$FilterResultResponseFromJson(
  Map<String, dynamic> json,
) =>
    FilterResultResponse(
      status: json['status'] as int,
      listings: (json['listings'] as List<dynamic>).map((e) => BaseCarDetailResponse.fromJson(e as Map<String, dynamic>)).toList(),
      limit: json['limit'],
      offset: json['offset'],
      showedParams: json['showed_paramms'],
    );

Map<String, dynamic> _$FilterResultResponseToJson(
  FilterResultResponse instance,
) =>
    <String, dynamic>{
      'status': instance.status,
      'listings': instance.listings,
      'limit': instance.limit,
      'offset': instance.offset,
      'showed_paramms': instance.showedParams,
    };
