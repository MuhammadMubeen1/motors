import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  AuthResponse(
    this.code,
    this.message,
    this.user,
    this.errors,
    this.restricted,
  );

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);

  final int? code;
  final String? message;
  final User? user;
  final dynamic errors;
  final dynamic restricted;

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

@JsonSerializable()
class User {
  User({
    required this.ID,
    this.userLogin,
    this.userNickname,
    this.userEmail,
    this.userUrl,
    this.userRegistered,
    this.userActivationKey,
    this.userStatus,
    this.displayName,
    this.spam,
    this.deleted,
    this.role,
    this.token,
    this.phone,
    this.firstName,
    this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  final String ID;
  @JsonKey(name: 'user_login')
  final String? userLogin;
  @JsonKey(name: 'user_nicename')
  final String? userNickname;
  @JsonKey(name: 'user_email')
  final String? userEmail;
  @JsonKey(name: 'user_url')
  final String? userUrl;
  @JsonKey(name: 'user_registered')
  final String? userRegistered;
  @JsonKey(name: 'user_activation_key')
  final String? userActivationKey;
  @JsonKey(name: 'user_status')
  final String? userStatus;
  @JsonKey(name: 'display_name')
  final String? displayName;
  final dynamic spam;
  final dynamic deleted;
  final dynamic role;
  final String? token;
  final String? phone;
  @JsonKey(name: 'f_name')
  final dynamic firstName;
  @JsonKey(name: 'l_name')
  final dynamic lastName;

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
