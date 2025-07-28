import 'package:json_annotation/json_annotation.dart';

part 'delete_car_response.g.dart';

@JsonSerializable()
class DeleteCarResponse {
  DeleteCarResponse({
    required this.status,
    required this.message,
  });

  factory DeleteCarResponse.fromJson(Map<String, dynamic> json) => _$DeleteCarResponseFromJson(json);

  final int? status;
  final String? message;

  Map<String, dynamic> toJson() => _$DeleteCarResponseToJson(this);
}
