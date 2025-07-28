// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dealer_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DealerResponse _$DealerResponseFromJson(Map<String, dynamic> json) => DealerResponse(
      author: json['author'] == null ? null : Author.fromJson(json['author'] as Map<String, dynamic>),
      listings: (json['listings'] as List<dynamic>?)
          ?.map(
            (e) => BaseCarDetailResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$DealerResponseToJson(DealerResponse instance) => <String, dynamic>{
      'author': instance.author,
      'listings': instance.listings,
    };

Author _$AuthorFromJson(Map<String, dynamic> json) => Author(
      user_id: json['user_id'],
      phone: json['phone'],
      stmWhatsappNumber: json['stm_whatsapp_number'],
      image: json['image'],
      name: json['name'],
      lastName: json['last_name'],
      socials: json['socials'],
      email: json['email'],
      showMail: json['show_mail'],
      logo: json['logo'],
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
    );

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      'user_id': instance.user_id,
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
    };
