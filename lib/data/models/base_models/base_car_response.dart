import 'package:json_annotation/json_annotation.dart';

part 'base_car_response.g.dart';

/*
{
            "ID": 2865,
            "imgUrl": "https://appmotors.stylemix.biz/wp-content/plugins/stm-motors-application/assets/img/car_plchldr.png",
            "gallery": [],
            "imgCount": 0,
            "price": "$19 000",
            "discountPrice": null,
            "sold": false,
            "grid": {
                "title": "Chevrolet Malibu",
                "subTitle": " 2015",
                "infoIcon": "road",
                "infoTitle": "Пробег",
                "infoDesc": "67500 mi"
            },
            "list": {
                "title": "Chevrolet Malibu 2015",
                "infoOneIcon": "body_type",
                "infoOneTitle": "Тип кузова",
                "infoOneDesc": "SUV",
                "infoTwoIcon": "road",
                "infoTwoTitle": "Пробег",
                "infoTwoDesc": "67500 mi",
                "infoThreeIcon": "transmission_fill",
                "infoThreeTitle": "КПП",
                "infoThreeDesc": "",
                "infoFourIcon": "fuel",
                "infoFourTitle": "Топливо",
                "infoFourDesc": ""
            }
        },
*/

/// This class is responsible for the general type
@JsonSerializable()
class BaseCarDetailResponse {
  BaseCarDetailResponse({
    this.key,
    required this.ID,
    this.imgUrl,
    required this.gallery,
    this.imgCount,
    this.price,
    this.discountPrice,
    required this.sold,
    required this.videoCount,
    required this.grid,
    required this.list,
  });

  factory BaseCarDetailResponse.fromJson(Map<String, dynamic> json) => _$BaseCarDetailResponseFromJson(json);

  /// This variable use in case:
  /// When we get info from api "private-user/${id}"
  /// Favourites response [favourites] first name of param = key: ...
  final int? key;

  final int ID;
  final String? imgUrl;
  final List<GalleryAuto?>? gallery;
  final int? imgCount;
  final String? price;
  final String? discountPrice;
  final bool? sold;
  @JsonKey(name: 'car_videos_count')
  final int? videoCount;
  final Grid? grid;
  final ListFav list;

  Map<String, dynamic> toJson() => _$BaseCarDetailResponseToJson(this);
}

@JsonSerializable()
class GalleryAuto {
  GalleryAuto({this.url});

  factory GalleryAuto.fromJson(Map<String, dynamic> json) => _$GalleryAutoFromJson(json);

  final String? url;

  Map<String, dynamic> toJson() => _$GalleryAutoToJson(this);
}

@JsonSerializable()
class Grid {
  Grid({
    this.title,
    this.subTitle,
    this.infoIcon,
    this.infoTitle,
    this.infoDesc,
  });

  factory Grid.fromJson(Map<String, dynamic> json) => _$GridFromJson(json);

  final String? title;
  final String? subTitle;
  final String? infoIcon;
  final String? infoTitle;
  final String? infoDesc;

  Map<String, dynamic> toJson() => _$GridToJson(this);
}

@JsonSerializable()
class ListFav {
  ListFav({
    this.title,
    this.infoOneIcon,
    this.infoOneTitle,
    this.infoOneDesc,
    this.infoTwoIcon,
    this.infoTwoTitle,
    this.infoTwoDesc,
    this.infoThreeIcon,
    this.infoThreeTitle,
    this.infoThreeDesc,
    this.infoFourIcon,
    this.infoFourTitle,
    this.infoFourDesc,
  });

  factory ListFav.fromJson(Map<String, dynamic> json) => _$ListFavFromJson(json);

  final String? title;
  final String? infoOneIcon;
  final String? infoOneTitle;
  final String? infoOneDesc;
  final String? infoTwoIcon;
  final String? infoTwoTitle;
  final String? infoTwoDesc;
  final String? infoThreeIcon;
  final String? infoThreeTitle;
  final String? infoThreeDesc;
  final String? infoFourIcon;
  final String? infoFourTitle;
  final String? infoFourDesc;

  Map<String, dynamic> toJson() => _$ListFavToJson(this);
}
