import 'package:json_annotation/json_annotation.dart';
import 'package:motors_app/data/models/base_models/base_featured_response.dart';

part 'car_detail_response.g.dart';

@JsonSerializable()
class CarDetailResponse {
  CarDetailResponse({
    required this.id,
    this.imgUrl,
    required this.gallery,
    this.imgCount,
    this.videoLink,
    this.videoPosterLink,
    required this.videoLinks,
    required this.videoCount,
    required this.price,
    this.discountPrice,
    required this.title,
    this.subTitle,
    this.content,
    required this.carLocation,
    required this.carLat,
    required this.carLng,
    required this.info,
    this.features,
    this.vin,
    this.sold,
    required this.author,
    this.listingSellerNote,
    required this.inFavorites,
    required this.similar,
  });

  factory CarDetailResponse.fromJson(Map<String, dynamic> json) => _$CarDetailResponseFromJson(json);

  @JsonKey(name: 'ID')
  final int id;
  final String? imgUrl;
  List<GalleryResponse>? gallery;
  final int? imgCount;
  final String? videoLink;
  final String? videoPosterLink;
  final List<VideoLinks?> videoLinks;
  @JsonKey(name: 'car_videos_count', defaultValue: 0)
  final int videoCount;
  final String price;
  final String? discountPrice;
  final String? title;
  final String? subTitle;
  final String? content;
  @JsonKey(name: 'car_location')
  final String carLocation;
  @JsonKey(name: 'car_lat')
  final String carLat;
  @JsonKey(name: 'car_lng')
  final String carLng;
  final List<InfoResponse?> info;
  final String? vin;
  final bool? sold;
  final List<String?>? features;
  final AuthorResponse author;
  @JsonKey(name: 'listing_seller_note')
  final String? listingSellerNote;
  final bool inFavorites;
  final List<BaseFeaturedResponse> similar;

  Map<String, dynamic> toJson() => _$CarDetailResponseToJson(this);
}

@JsonSerializable()
class GalleryResponse {
  GalleryResponse(this.url);

  factory GalleryResponse.fromJson(Map<String, dynamic> json) => _$GalleryResponseFromJson(json);

  final String url;

  Map<String, dynamic> toJson() => _$GalleryResponseToJson(this);
}

@JsonSerializable()
class InfoResponse {
  InfoResponse(
    this.infoOne,
    this.infoTwo,
    this.infoThree,
  );

  factory InfoResponse.fromJson(Map<String, dynamic> json) => _$InfoResponseFromJson(json);

  @JsonKey(name: 'info_1')
  final String? infoOne;
  @JsonKey(name: 'info_2')
  final String? infoTwo;
  @JsonKey(name: 'info_3')
  final String? infoThree;

  Map<String, dynamic> toJson() => _$InfoResponseToJson(this);
}

@JsonSerializable()
class AuthorResponse {
  AuthorResponse({
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
    required this.dealerImage,
    required this.license,
    required this.website,
    required this.location,
    required this.locationLat,
    required this.locationLng,
    required this.stmCompanyName,
    required this.stmCompanyLicense,
    required this.stmMessageToUser,
    required this.stmSalesHours,
    required this.stmSellerNotes,
    required this.stmPaymentStatus,
    required this.userRole,
    required this.regDate,
  });

  factory AuthorResponse.fromJson(Map<String, dynamic> json) => _$AuthorResponseFromJson(json);

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
  final String? dealerImage;
  final String? license;
  final String? website;
  final String? location;
  @JsonKey(name: 'location_lat')
  final String? locationLat;
  @JsonKey(name: 'location_lng')
  final String? locationLng;
  @JsonKey(name: 'stm_company_name')
  final String? stmCompanyName;
  @JsonKey(name: 'stm_company_license')
  final String? stmCompanyLicense;
  @JsonKey(name: 'stm_message_to_user')
  final String? stmMessageToUser;
  @JsonKey(name: 'stm_sales_hours')
  final String? stmSalesHours;
  @JsonKey(name: 'stm_seller_notes')
  final String? stmSellerNotes;
  @JsonKey(name: 'stm_payment_status')
  final String? stmPaymentStatus;
  @JsonKey(name: 'user_role')
  final String? userRole;
  @JsonKey(name: 'reg_date')
  final String? regDate;

  Map<String, dynamic> toJson() => _$AuthorResponseToJson(this);
}

@JsonSerializable()
class VideoLinks {
  VideoLinks({
    required this.videoLink,
    required this.video_posters,
  });

  factory VideoLinks.fromJson(Map<String, dynamic> json) => _$VideoLinksFromJson(json);

  @JsonKey(name: 'video_link')
  final String videoLink;
  @JsonKey(name: 'video_posters')
  final String? video_posters;

  Map<String, dynamic> toJson() => _$VideoLinksToJson(this);
}
