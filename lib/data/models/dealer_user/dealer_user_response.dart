import 'package:json_annotation/json_annotation.dart';
import 'package:motors_app/data/models/base_models/base_car_response.dart';

part 'dealer_user_response.g.dart';

@JsonSerializable()
class DealerResponse {
  DealerResponse({this.author, required this.listings});

  factory DealerResponse.fromJson(Map<String, dynamic> json) => _$DealerResponseFromJson(json);

  final Author? author;
  final List<BaseCarDetailResponse>? listings;

  Map<String, dynamic> toJson() => _$DealerResponseToJson(this);
}

@JsonSerializable()
class Author {
  Author({
    this.user_id,
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
  });

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

  @JsonKey(name: 'user_id')
  dynamic user_id;
  dynamic phone;
  @JsonKey(name: 'stm_whatsapp_number')
  dynamic stmWhatsappNumber;
  dynamic image;
  dynamic name;
  @JsonKey(name: 'last_name')
  dynamic lastName;
  dynamic socials;
  dynamic email;
  @JsonKey(name: 'show_mail')
  dynamic showMail;
  dynamic logo;
  @JsonKey(name: 'dealer_image')
  dynamic dealerImage;
  dynamic license;
  dynamic website;
  dynamic location;
  @JsonKey(name: 'location_lat')
  dynamic locationLat;
  @JsonKey(name: 'location_lng')
  dynamic locationLng;
  @JsonKey(name: 'stm_company_name')
  dynamic stmCompanyName;
  @JsonKey(name: 'stm_company_license')
  dynamic stmCompanyLicense;
  @JsonKey(name: 'stm_message_to_user')
  dynamic stmMessageToUser;
  @JsonKey(name: 'stm_sales_hours')
  dynamic stmSalesHours;
  @JsonKey(name: 'stm_seller_notes')
  dynamic stmSellerNotes;
  @JsonKey(name: 'stm_payment_status')
  dynamic stmPaymentStatus;

  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}
