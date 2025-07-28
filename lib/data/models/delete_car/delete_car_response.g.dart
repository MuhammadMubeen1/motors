// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_car_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteCarResponse _$DeleteCarResponseFromJson(Map<String, dynamic> json) =>
    DeleteCarResponse(
      status: json['status'] as int?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$DeleteCarResponseToJson(DeleteCarResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };
