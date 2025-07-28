// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:motors_app/presentation/screens/car_detail/car_detail_screen.dart'
//     show CarDetailScreen;

// class BrowseByBody extends StatefulWidget {
//   final makeName;

//   const BrowseByBody({
//     Key? key,
//     required this.makeName,
//   }) : super(key: key);

//   @override
//   _BMWListScreenState createState() => _BMWListScreenState();
// }

// class _BMWListScreenState extends State<BrowseByBody> {
//   List<dynamic> listings = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchBMWListings();
//   }

//   Future<void> fetchBMWListings() async {
//     try {
//       final response = await http.get(Uri.parse(
//           'https://wheelers.pk/wp-json/stm-mra/v1/filtered-listings?body%5B0%5D=${widget.makeName}'));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           listings = data['listings'];
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load listings');
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error loading data: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Browse by Body',
//           style: TextStyle(color: Colors.black),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         // backgroundColor: Colors.white,
//         elevation: 3,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : listings.isEmpty
//                 ? const Center(child: Text('No cars found'))
//                 : ListView.builder(
//                     itemCount: listings.length,
//                     itemBuilder: (context, index) {
//                       final car = listings[index];
//                       return Card(
//                         color: Colors.white,
//                         margin: const EdgeInsets.all(8),
//                         child: ListTile(
//                           leading: Image.network(
//                             car['imgUrl'],
//                             width: 80,
//                             height: 80,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) =>
//                                 const Icon(Icons.car_repair),
//                           ),
//                           title: Text(car['grid']['title']),
//                           subtitle: Text(car['price']),
//                           trailing: const Icon(Icons.arrow_forward),
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     CarDetailScreen(idCar: car['ID']),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   ),
//       ),
//     );
//   }
// }


import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/app_color.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/data/models/base_models/base_car_response.dart';
import 'package:motors_app/presentation/screens/car_detail/car_detail_screen.dart';
import 'package:motors_app/presentation/widgets/loader_widget.dart';

class BrowseByBody extends StatefulWidget {
  final String makeName;

  const BrowseByBody({Key? key, required this.makeName}) : super(key: key);

  @override
  _BMWListScreenState createState() => _BMWListScreenState();
}

class _BMWListScreenState extends State<BrowseByBody> {
  List<dynamic> listings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBMWListings();
  }

  Future<void> fetchBMWListings() async {
    try {
      final response = await http.get(Uri.parse(
          'https://wheelers.pk/wp-json/stm-mra/v1/filtered-listings?body%5B0%5D=${widget.makeName}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          listings = data['listings'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load listings');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.makeName}',
            style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 3,
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: LoaderWidget())
          : listings.isEmpty
              ? Center(child: Text('no_cars_found'.tr()))
              : ListView.builder(
                  itemCount: listings.length,
                  itemBuilder: (context, index) {
                    final car = listings[index];
                    return CarGridItem(
                      car: car,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarDetailScreen(
                              idCar: car['ID'],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

class CarGridItem extends StatelessWidget {
  final dynamic car;
  final VoidCallback onTap;

  const CarGridItem({
    Key? key,
    required this.car,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: const Color(0xffF3F3F3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CachedNetworkImage(
                    height: 170,
                    width: double.infinity,
                    imageUrl: car['imgUrl'] ?? '',
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => LoaderWidget(
                      loaderColor: Colors.white,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  if (car['imgCount'] != null && car['imgCount'] > 0)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.15),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              IconsMotors.addPhoto,
                              size: 15,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${car['imgCount']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price
                  if (car['sold'] == true)
                    ColoredBox(
                      color: ColorApp.mainColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: Text(
                          'sold'.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  else if (car['discountPrice'] != null &&
                      car['discountPrice'] != '')
                    ColoredBox(
                      color: ColorApp.mainColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 7),
                        child: Column(
                          children: [
                            Text(
                              car['discountPrice'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              car['price'] != null && car['price'] != ''
                                  ? car['price']
                                  : 'No price',
                              style: const TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ColoredBox(
                      color: ColorApp.mainColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: Text(
                          car['price'] != null && car['price'] != ''
                              ? car['price']
                              : 'No price',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 5.0, left: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  car['grid']?['subTitle'] ?? 'no_info'.tr(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  car['grid']?['title'] ?? 'no_info'.tr(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Icon(
                                  dictionaryIcons[car['grid']?['infoIcon']] ??
                                      Icons.info,
                                  size: 15,
                                  color: ColorApp.mainColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5.0, right: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        car['grid']?['infoTitle'] ??
                                            'no_info'.tr(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: ColorApp.grey1,
                                        ),
                                      ),
                                      Text(
                                        car['grid']?['infoDesc'] ??
                                            'no_info'.tr(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
