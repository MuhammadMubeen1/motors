// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
      json['code'] as int?,
      json['message'] as String?,
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      json['errors'],
      json['restricted'],
    );

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'user': instance.user,
      'errors': instance.errors,
      'restricted': instance.restricted,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      ID: json['ID'] as String,
      userLogin: json['user_login'] as String?,
      userNickname: json['user_nicename'] as String?,
      userEmail: json['user_email'] as String?,
      userUrl: json['user_url'] as String?,
      userRegistered: json['user_registered'] as String?,
      userActivationKey: json['user_activation_key'] as String?,
      userStatus: json['user_status'] as String?,
      displayName: json['display_name'] as String?,
      spam: json['spam'],
      deleted: json['deleted'],
      role: json['role'],
      token: json['token'] as String?,
      phone: json['phone'] as String?,
      firstName: json['f_name'],
      lastName: json['l_name'],
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'ID': instance.ID,
      'user_login': instance.userLogin,
      'user_nicename': instance.userNickname,
      'user_email': instance.userEmail,
      'user_url': instance.userUrl,
      'user_registered': instance.userRegistered,
      'user_activation_key': instance.userActivationKey,
      'user_status': instance.userStatus,
      'display_name': instance.displayName,
      'spam': instance.spam,
      'deleted': instance.deleted,
      'role': instance.role,
      'token': instance.token,
      'phone': instance.phone,
      'f_name': instance.firstName,
      'l_name': instance.lastName,
    };
