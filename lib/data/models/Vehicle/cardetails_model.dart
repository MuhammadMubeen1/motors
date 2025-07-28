// car_listing_model.dart
class CarListings {
  final String id;
  final String imgUrl;
  final List<GalleryImage> gallery;
  final String price;
  final GridInfo grid;
  final ListInfo list;

  CarListings({
    required this.id,
    required this.imgUrl,
    required this.gallery,
    required this.price,
    required this.grid,
    required this.list,
  });

  factory CarListings.fromJson(Map<String, dynamic> json) {
    return CarListings(
      id: json['ID'].toString(),
      imgUrl: json['imgUrl'] ?? '',
      gallery: (json['gallery'] as List<dynamic>?)
              ?.map((item) => GalleryImage.fromJson(item))
              .toList() ??
          [],
      price: json['price'] ?? 'Price not available',
      grid: GridInfo.fromJson(json['grid']),
      list: ListInfo.fromJson(json['list']),
    );
  }

  String get make => grid.title.split(' ').first;
}

class GalleryImage {
  final String url;

  GalleryImage({required this.url});

  factory GalleryImage.fromJson(Map<String, dynamic> json) {
    return GalleryImage(
      url: json['url'] ?? '',
    );
  }
}

class GridInfo {
  final String title;
  final String subTitle;
  final String infoIcon;
  final String infoTitle;
  final String infoDesc;

  GridInfo({
    required this.title,
    required this.subTitle,
    required this.infoIcon,
    required this.infoTitle,
    required this.infoDesc,
  });

  factory GridInfo.fromJson(Map<String, dynamic> json) {
    return GridInfo(
      title: json['title'] ?? '',
      subTitle: json['subTitle'] ?? '',
      infoIcon: json['infoIcon'] ?? '',
      infoTitle: json['infoTitle'] ?? '',
      infoDesc: json['infoDesc'] ?? '',
    );
  }
}

class ListInfo {
  final String title;
  final String infoOneIcon;
  final String infoOneTitle;
  final String infoOneDesc;
  final String infoTwoIcon;
  final String infoTwoTitle;
  final String infoTwoDesc;
  final String infoThreeIcon;
  final String infoThreeTitle;
  final String infoThreeDesc;

  ListInfo({
    required this.title,
    required this.infoOneIcon,
    required this.infoOneTitle,
    required this.infoOneDesc,
    required this.infoTwoIcon,
    required this.infoTwoTitle,
    required this.infoTwoDesc,
    required this.infoThreeIcon,
    required this.infoThreeTitle,
    required this.infoThreeDesc,
  });

  factory ListInfo.fromJson(Map<String, dynamic> json) {
    return ListInfo(
      title: json['title'] ?? '',
      infoOneIcon: json['infoOneIcon'] ?? '',
      infoOneTitle: json['infoOneTitle'] ?? '',
      infoOneDesc: json['infoOneDesc'] ?? '',
      infoTwoIcon: json['infoTwoIcon'] ?? '',
      infoTwoTitle: json['infoTwoTitle'] ?? '',
      infoTwoDesc: json['infoTwoDesc'] ?? '',
      infoThreeIcon: json['infoThreeIcon'] ?? '',
      infoThreeTitle: json['infoThreeTitle'] ?? '',
      infoThreeDesc: json['infoThreeDesc'] ?? '',
    );
  }
}
