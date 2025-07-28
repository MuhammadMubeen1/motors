import 'package:json_annotation/json_annotation.dart';
import 'package:motors_app/data/models/base_models/base_car_response.dart';

part 'user_response.g.dart';

@JsonSerializable()
class UserInfoResponse {
  UserInfoResponse(
    this.author,
    this.listingsFound,
    this.listings,
    this.favouritesFound,
    this.favourites,
  );

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) => _$UserInfoResponseFromJson(json);

  final Author author;
  @JsonKey(name: 'listings_found')
  final int listingsFound;
  final List<BaseCarDetailResponse> listings;
  @JsonKey(name: 'favourites_found')
  final int? favouritesFound;
  final List<BaseCarDetailResponse>? favourites;

  Map<String, dynamic> toJson() => _$UserInfoResponseToJson(this);
}

@JsonSerializable()
class Author {
  Author({
    this.userId,
    this.phone,
    this.stmWhatsappNumber,
    this.image,
    this.name,
    this.lastName,
    this.socials,
    this.email,
    this.showMail,
    this.logo,
    this.dealerImage,
    this.license,
    this.website,
    this.location,
    this.locationLat,
    this.locationLng,
    this.stmCompanyName,
    this.stmCompanyLicense,
    this.stmMessageToUser,
    this.stmSalesHours,
    this.stmSellerNotes,
    this.stmPaymentStatus,
    this.username,
  });

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

  @JsonKey(name: 'user_id')
  final String? userId;
  final String? phone;
  @JsonKey(name: 'stm_whatsapp_number')
  final String? stmWhatsappNumber;
  final String? image;
  final String? name;
  @JsonKey(name: 'last_name')
  final String? lastName;
  final dynamic socials;
  final String? email;
  @JsonKey(name: 'show_mail')
  final String? showMail;
  final String? logo;
  @JsonKey(name: 'dealer_image')
  final dynamic dealerImage;
  final dynamic license;
  final dynamic website;
  final dynamic location;
  @JsonKey(name: 'location_lat')
  final dynamic locationLat;
  @JsonKey(name: 'location_lng')
  final dynamic locationLng;
  @JsonKey(name: 'stm_company_name')
  final dynamic stmCompanyName;
  @JsonKey(name: 'stm_company_license')
  final dynamic stmCompanyLicense;
  @JsonKey(name: 'stm_message_to_user')
  final dynamic stmMessageToUser;
  @JsonKey(name: 'stm_sales_hours')
  final dynamic stmSalesHours;
  @JsonKey(name: 'stm_seller_notes')
  final dynamic stmSellerNotes;
  @JsonKey(name: 'stm_payment_status')
  final dynamic stmPaymentStatus;
  final dynamic username;

  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}
