// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoResponse _$UserInfoResponseFromJson(Map<String, dynamic> json) => UserInfoResponse(
      Author.fromJson(json['author'] as Map<String, dynamic>),
      json['listings_found'] as int,
      (json['listings'] as List<dynamic>).map((e) => BaseCarDetailResponse.fromJson(e as Map<String, dynamic>)).toList(),
      json['favourites_found'] as int?,
      (json['favourites'] as List<dynamic>?)
          ?.map(
            (e) => BaseCarDetailResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$UserInfoResponseToJson(UserInfoResponse instance) => <String, dynamic>{
      'author': instance.author,
      'listings_found': instance.listingsFound,
      'listings': instance.listings,
      'favourites_found': instance.favouritesFound,
      'favourites': instance.favourites,
    };

Author _$AuthorFromJson(Map<String, dynamic> json) => Author(
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
      dealerImage: json['dealer_image'],
      license: json['license'],
      website: json['website'],
      location: json['location'],
      locationLat: json['location_lat'],
      locationLng: json['location_lng'],
      stmCompanyName: json['stm_company_name'],
      stmCompanyLicense: json['stm_company_license'],
      stmMessageToUser: json['stm_message_to_user'],
      stmSalesHours: json['stm_sales_hours'],
      stmSellerNotes: json['stm_seller_notes'],
      stmPaymentStatus: json['stm_payment_status'],
      username: json['username'],
    );

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
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
      'username': instance.username,
    };
