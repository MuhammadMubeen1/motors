import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/core/styles/app_color.dart';
import 'package:motors_app/data/models/base_models/base_featured_response.dart';
import 'package:motors_app/presentation/screens/car_detail/car_detail_screen.dart';
import 'package:motors_app/presentation/widgets/loader_widget.dart';

class RecommendedWidget extends StatelessWidget {
  const RecommendedWidget({
    Key? key,
    required this.featuredItem,
  }) : super(key: key);

  final List<BaseFeaturedResponse> featuredItem;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xff1f2224),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Text "RECOMMENDED"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Text(
              'recomended'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          // Items
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: featuredItem
                  .map(
                    (item) => Container(
                      width: 180,
                      margin: const EdgeInsets.only(left: 20, right: 10, bottom: 20),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CarDetailScreen(
                                idCar: item.id,
                              ),
                            ),
                          );
                        },
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                            color: Color(0xff323536),
                            // color: Colors.red,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  CachedNetworkImage(
                                    height: 165,
                                    imageUrl: item.img ?? '',
                                    fit: BoxFit.fitHeight,
                                    placeholder: (context, url) => LoaderWidget(
                                      loaderColor: Colors.white,
                                    ),
                                    errorWidget: (context, url, error) => SizedBox(
                                      width: double.infinity,
                                      child: const Icon(
                                        Icons.error,
                                      ),
                                    ),
                                  ),
                                  if (item.discountPrice != null && item.discountPrice != '')
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: ColorApp.mainColor,
                                        ),
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(minWidth: 70, maxWidth: 90),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  item.discountPrice ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  item.price != null && item.price != '' ? item.price! : 'No price',
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration.lineThrough,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  else
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: ColorApp.mainColor,
                                        ),
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(minWidth: 70, maxWidth: 90),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                            child: Text(
                                              item.price != null && item.price != '' ? item.price! : 'No price',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(
                                height: 50,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                                  child: Text(
                                    item.title != null && item.title != '' ? item.title! : '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
