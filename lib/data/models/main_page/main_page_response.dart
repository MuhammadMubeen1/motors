import 'package:json_annotation/json_annotation.dart';
import 'package:motors_app/data/models/base_models/base_car_response.dart';
import 'package:motors_app/data/models/base_models/base_featured_response.dart';

part 'main_page_response.g.dart';

@JsonSerializable()
class MainPageResponse {
  MainPageResponse({
    required this.featured,
    required this.recent,
    required this.viewType,
    this.offset,
    this.limit,
    this.featuredMaxNumPages,
    this.lastMaxNumPages,
  });

  factory MainPageResponse.fromJson(Map<String, dynamic> json) => _$MainPageResponseFromJson(json);

  final List<BaseFeaturedResponse> featured;
  final List<BaseCarDetailResponse>? recent;
  final String viewType;
  final String? offset;
  final String? limit;
  @JsonKey(name: 'featured_max_num_pages')
  final int? featuredMaxNumPages;
  @JsonKey(name: 'last_max_num_pages')
  final int? lastMaxNumPages;

  Map<String, dynamic> toJson() => _$MainPageResponseToJson(this);
}
