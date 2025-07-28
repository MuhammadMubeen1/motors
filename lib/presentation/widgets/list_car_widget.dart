import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/core/styles/app_color.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/data/models/base_models/base_car_response.dart';

class ListCarWidget extends StatelessWidget {
  const ListCarWidget({
    super.key,
    required this.item,
    this.bgColor,
    this.onTap,
    this.onLongPress,
    this.removeFromFavorites,
    this.isFavourite,
    this.additionalBottomWidget,
  });

  final BaseCarDetailResponse item;

  /// Background Color use in one case, on Profile screen,
  /// when we long press on inventory car
  final Color? bgColor;

  final VoidCallback? onTap;

  /// Use only for fav car, when we want remove car
  final VoidCallback? removeFromFavorites;

  /// Use only for My Favourites Car in Profile Screen
  final bool? isFavourite;

  /// This param we use in case:
  /// Profile screen, when we want delete and update info of inventory car
  final Function()? onLongPress;

  final Widget? additionalBottomWidget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.only(top: 20, bottom: 20, left: 10),
        decoration: BoxDecoration(
          color: bgColor,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(2)),
                          child: CachedNetworkImage(
                            imageUrl: item.imgUrl!,
                            height: 125,
                            width: 150,
                            fit: BoxFit.fitHeight,
                            errorWidget: (BuildContext context, String url, dynamic error) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                              );
                            },
                          ),
                        ),
                        if (item.sold ?? false)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: ColorApp.mainColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                                child: Text(
                                  'sold'.tr(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        else if (item.discountPrice != null && item.discountPrice != '')
                          Positioned(
                            top: 0,
                            right: 0,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: ColorApp.mainColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
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
                          )
                        else
                          Positioned(
                            top: 0,
                            right: 0,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: ColorApp.mainColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                                child: Text(
                                  item.price != null && item.price != '' ? item.price! : 'No info',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        // This widget used only for fav car
                        if (isFavourite != null)
                          Container(
                            margin: const EdgeInsets.only(right: 5),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              onTap: removeFromFavorites,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.favorite_rounded,
                                  color: isFavourite ?? false ? Colors.red : null,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.list.title ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 1.0),
                                  child: Icon(
                                    dictionaryIcons[item.list.infoOneIcon],
                                    color: ColorApp.mainColor,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.list.infoOneTitle ?? 'no_info'.tr(),
                                        style: TextStyle(
                                          color: ColorApp.grey1,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        item.list.infoOneDesc != null && item.list.infoOneDesc != '' ? item.list.infoOneDesc ?? 'No info' : 'No info',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 1.0),
                                  child: Icon(
                                    dictionaryIcons[item.list.infoTwoIcon],
                                    color: ColorApp.mainColor,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.list.infoTwoTitle ?? '',
                                        style: TextStyle(
                                          color: ColorApp.grey1,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        item.list.infoTwoDesc != null && item.list.infoTwoDesc != '' ? item.list.infoTwoDesc! : 'No info',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
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
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 1.0),
                                  child: Icon(
                                    dictionaryIcons[item.list.infoThreeIcon],
                                    color: ColorApp.mainColor,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.list.infoThreeTitle ?? '',
                                        style: TextStyle(
                                          color: ColorApp.grey1,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        item.list.infoThreeDesc != null && item.list.infoThreeDesc != '' ? item.list.infoThreeDesc! : 'No info',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 1.0),
                                  child: Icon(
                                    dictionaryIcons[item.list.infoFourIcon],
                                    color: ColorApp.mainColor,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.list.infoFourTitle ?? '',
                                        style: TextStyle(
                                          color: ColorApp.grey1,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        item.list.infoFourDesc != null && item.list.infoFourDesc != '' ? item.list.infoFourDesc! : 'No info',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
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
              ],
            ),
            if (additionalBottomWidget != null) ...[
              additionalBottomWidget!,
            ],
          ],
        ),
      ),
    );
  }
}
