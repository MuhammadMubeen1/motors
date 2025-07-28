import 'package:json_annotation/json_annotation.dart';

part 'app_settings_response.g.dart';

enum AppType { dealership, classified }

@JsonSerializable()
class AppSettingsResponse {
  AppSettingsResponse({
    required this.acv,
    required this.appType,
    required this.mainColor,
    required this.secondaryColor,
    required this.numOfListings,
    required this.gridViewStyle,
    required this.inventoryView,
    required this.apiKeyAndroid,
    required this.apiKeyIos,
    required this.currency,
    required this.currencyName,
    required this.translations,
    this.logo,
    this.splashScreenLogo,
    this.backgroundSplashScreenImage,
    this.placeholder,
  });

  factory AppSettingsResponse.fromJson(Map<String, dynamic> json) => _$AppSettingsResponseFromJson(json);

  final String acv;
  @JsonKey(name: 'app_type')
  final AppType appType;
  @JsonKey(name: 'main_color')
  final String mainColor;
  @JsonKey(name: 'secondary_color')
  final String secondaryColor;
  @JsonKey(name: 'num_of_listings')
  final int numOfListings;
  @JsonKey(name: 'grid_view_style')
  final String gridViewStyle;
  @JsonKey(name: 'inventory_view')
  final String inventoryView;
  @JsonKey(name: 'api_key_android')
  final String apiKeyAndroid;
  @JsonKey(name: 'api_key_ios')
  final String apiKeyIos;
  final String currency;
  @JsonKey(name: 'currency_name')
  final String currencyName;
  final dynamic translations;
  final String? logo;
  @JsonKey(name: 'splash_screen_logo')
  final String? splashScreenLogo;
  @JsonKey(name: 'background_splash_screen_image')
  final String? backgroundSplashScreenImage;
  final String? placeholder;

  Map<String, dynamic> toJson() => _$AppSettingsResponseToJson(this);
}
