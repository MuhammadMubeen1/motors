import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/app_color.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/data/models/base_models/base_car_response.dart';
import 'package:motors_app/presentation/widgets/loader_widget.dart';

class GridCarWidget extends StatelessWidget {
  const GridCarWidget({
    super.key,
    this.onTap,
    required this.item,
  });

  final BaseCarDetailResponse item;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
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
                    imageUrl: '${item.imgUrl}',
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => LoaderWidget(
                      loaderColor: Colors.white,
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                  if (item.imgCount != 0)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.15), borderRadius: const BorderRadius.all(Radius.circular(5))),
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(right: 8, top: 8),
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
                              '${item.imgCount}',
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
                  if (item.videoCount != 0)
                    Positioned(
                      right: 40,
                      top: 0.5,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.15), borderRadius: const BorderRadius.all(Radius.circular(5))),
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(right: 8, top: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              IconsMotors.video,
                              size: 15,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${item.videoCount}',
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
                  if (item.sold ?? false)
                    ColoredBox(
                      color: ColorApp.mainColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                  else if (item.discountPrice != null && item.discountPrice != '')
                    ColoredBox(
                      color: ColorApp.mainColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        child: Column(
                          children: [
                            Text(
                              item.discountPrice ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              item.price != null && item.price != '' ? item.price! : 'No price',
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
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Text(
                          item.price != null && item.price != '' ? item.price! : 'No price',
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
                            padding: const EdgeInsets.only(top: 5.0, left: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.grid?.subTitle ?? 'no_info'.tr(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  item.grid?.title ?? 'no_info'.tr(),
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
                                  dictionaryIcons[item.grid?.infoIcon],
                                  size: 15,
                                  color: ColorApp.mainColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0, right: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.grid?.infoTitle != null && item.grid!.infoTitle!.isNotEmpty ? item.grid!.infoTitle! : 'no_info'.tr(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: ColorApp.grey1,
                                        ),
                                      ),
                                      Text(
                                        item.grid!.infoDesc != null && item.grid!.infoDesc!.isNotEmpty ? item.grid!.infoDesc! : 'no_info'.tr(),
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
