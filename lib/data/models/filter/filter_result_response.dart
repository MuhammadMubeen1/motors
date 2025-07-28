import 'package:json_annotation/json_annotation.dart';
import 'package:motors_app/data/models/base_models/base_car_response.dart';

part 'filter_result_response.g.dart';

@JsonSerializable()
class FilterResultResponse {
  FilterResultResponse({
    required this.status,
    required this.listings,
    required this.limit,
    required this.offset,
    required this.showedParams,
  });

  factory FilterResultResponse.fromJson(Map<String, dynamic> json) => _$FilterResultResponseFromJson(json);

  final int status;
  final List<BaseCarDetailResponse> listings;

  // Not strictly typed variable ['-1'/ -1]
  final dynamic limit;

  // Not strictly typed variable ['-1'/ -1]
  final dynamic offset;
  @JsonKey(name: 'showed_paramms')
  final dynamic showedParams;

  Map<String, dynamic> toJson() => _$FilterResultResponseToJson(this);
}
