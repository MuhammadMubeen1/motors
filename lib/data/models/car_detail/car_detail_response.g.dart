// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarDetailResponse _$CarDetailResponseFromJson(Map<String, dynamic> json) => CarDetailResponse(
      id: json['ID'] as int,
      imgUrl: json['imgUrl'] as String?,
      gallery: (json['gallery'] as List<dynamic>?)?.map((e) => GalleryResponse.fromJson(e as Map<String, dynamic>)).toList(),
      imgCount: json['imgCount'] as int?,
      videoLink: json['videoLink'] as String?,
      videoPosterLink: json['videoPosterLink'] as String?,
      videoLinks: (json['videoLinks'] as List<dynamic>)
          .map(
            (e) => e == null ? null : VideoLinks.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      videoCount: json['car_videos_count'] as int? ?? 0,
      price: json['price'] as String,
      discountPrice: json['discountPrice'] as String?,
      title: json['title'] as String?,
      subTitle: json['subTitle'] as String?,
      content: json['content'] as String?,
      carLocation: json['car_location'] as String,
      carLat: json['car_lat'] as String,
      carLng: json['car_lng'] as String,
      info: (json['info'] as List<dynamic>)
          .map(
            (e) => e == null ? null : InfoResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      features: (json['features'] as List<dynamic>?)?.map((e) => e as String?).toList(),
      vin: json['vin'] as String?,
      sold: json['sold'] as bool?,
      author: AuthorResponse.fromJson(json['author'] as Map<String, dynamic>),
      listingSellerNote: json['listing_seller_note'] as String?,
      inFavorites: json['inFavorites'] as bool,
      similar: (json['similar'] as List<dynamic>).map((e) => BaseFeaturedResponse.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$CarDetailResponseToJson(CarDetailResponse instance) => <String, dynamic>{
      'ID': instance.id,
      'imgUrl': instance.imgUrl,
      'gallery': instance.gallery,
      'imgCount': instance.imgCount,
      'videoLink': instance.videoLink,
      'videoPosterLink': instance.videoPosterLink,
      'videoLinks': instance.videoLinks,
      'car_videos_count': instance.videoCount,
      'price': instance.price,
      'discountPrice': instance.discountPrice,
      'title': instance.title,
      'subTitle': instance.subTitle,
      'content': instance.content,
      'car_location': instance.carLocation,
      'car_lat': instance.carLat,
      'car_lng': instance.carLng,
      'info': instance.info,
      'vin': instance.vin,
      'sold': instance.sold,
      'features': instance.features,
      'author': instance.author,
      'listing_seller_note': instance.listingSellerNote,
      'inFavorites': instance.inFavorites,
      'similar': instance.similar,
    };

GalleryResponse _$GalleryResponseFromJson(Map<String, dynamic> json) => GalleryResponse(
      json['url'] as String,
    );

Map<String, dynamic> _$GalleryResponseToJson(GalleryResponse instance) => <String, dynamic>{
      'url': instance.url,
    };

InfoResponse _$InfoResponseFromJson(Map<String, dynamic> json) => InfoResponse(
      json['info_1'] as String?,
      json['info_2'] as String?,
      json['info_3'] as String?,
    );

Map<String, dynamic> _$InfoResponseToJson(InfoResponse instance) => <String, dynamic>{
      'info_1': instance.infoOne,
      'info_2': instance.infoTwo,
      'info_3': instance.infoThree,
    };

AuthorResponse _$AuthorResponseFromJson(Map<String, dynamic> json) => AuthorResponse(
      userId: json['user_id'] as String?,
      phone: json['phone'] as String?,
      stmWhatsappNumber: json['stm_whatsapp_number'] as String?,
      image: json['image'] as String?,
      name: json['name'] as String?,
      lastName: json['last_name'] as String?,
      socials: json['socials'],
      email: json['email'] as String?,
      showMail: json['show_mail'] as String?,
      logo: json['logo'] as String?,
      dealerImage: json['dealer_image'] as String?,
      license: json['license'] as String?,
      website: json['website'] as String?,
      location: json['location'] as String?,
      locationLat: json['location_lat'] as String?,
      locationLng: json['location_lng'] as String?,
      stmCompanyName: json['stm_company_name'] as String?,
      stmCompanyLicense: json['stm_company_license'] as String?,
      stmMessageToUser: json['stm_message_to_user'] as String?,
      stmSalesHours: json['stm_sales_hours'] as String?,
      stmSellerNotes: json['stm_seller_notes'] as String?,
      stmPaymentStatus: json['stm_payment_status'] as String?,
      userRole: json['user_role'] as String?,
      regDate: json['reg_date'] as String?,
    );

Map<String, dynamic> _$AuthorResponseToJson(AuthorResponse instance) => <String, dynamic>{
      'user_id': instance.userId,
      'phone': instance.phone,
      'stm_whatsapp_number': instance.stmWhatsappNumber,
      'image': instance.image,
      'name': instance.name,
      'last_name': instance.lastName,
      'socials': instance.socials,
      'email': instance.email,
      'show_mail': instance.showMail,
      'logo': instance.logo,
      'dealer_image': instance.dealerImage,
      'license': instance.license,
      'website': instance.website,
      'location': instance.location,
      'location_lat': instance.locationLat,
      'location_lng': instance.locationLng,
      'stm_company_name': instance.stmCompanyName,
      'stm_company_license': instance.stmCompanyLicense,
      'stm_message_to_user': instance.stmMessageToUser,
      'stm_sales_hours': instance.stmSalesHours,
      'stm_seller_notes': instance.stmSellerNotes,
      'stm_payment_status': instance.stmPaymentStatus,
      'user_role': instance.userRole,
      'reg_date': instance.regDate,
    };

VideoLinks _$VideoLinksFromJson(Map<String, dynamic> json) => VideoLinks(
      videoLink: json['video_link'] as String,
      video_posters: json['video_posters'] as String?,
    );

Map<String, dynamic> _$VideoLinksToJson(VideoLinks instance) => <String, dynamic>{
      'video_link': instance.videoLink,
      'video_posters': instance.video_posters,
    };
