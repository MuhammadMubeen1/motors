// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restore_password_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestorePasswordResponse _$RestorePasswordResponseFromJson(
  Map<String, dynamic> json,
) =>
    RestorePasswordResponse(
      json['message'] as String?,
      json['errors'] as List<dynamic>,
    );

Map<String, dynamic> _$RestorePasswordResponseToJson(
  RestorePasswordResponse instance,
) =>
    <String, dynamic>{
      'message': instance.message,
      'errors': instance.errors,
    };
