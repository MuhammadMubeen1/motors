
import 'package:json_annotation/json_annotation.dart';

part 'restore_password_response.g.dart';

@JsonSerializable()
class RestorePasswordResponse {
  RestorePasswordResponse(this.message, this.errors);

  factory RestorePasswordResponse.fromJson(Map<String, dynamic> json) => _$RestorePasswordResponseFromJson(json);

  final String? message;
  final List<dynamic> errors;

  Map<String, dynamic> toJson() => _$RestorePasswordResponseToJson(this);
}