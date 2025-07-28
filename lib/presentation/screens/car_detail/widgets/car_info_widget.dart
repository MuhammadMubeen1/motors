import 'package:flutter/material.dart';
import 'package:motors_app/core/styles/app_color.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/data/models/car_detail/car_detail_response.dart';

class CarInfoWidget extends StatelessWidget {
  const CarInfoWidget({Key? key, required this.carDetailResponse}) : super(key: key);

  final CarDetailResponse carDetailResponse;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        children: carDetailResponse.info.map(
          (item) {
            if (item?.infoTwo == '' || item?.infoTwo == null) {
              return const SizedBox();
            } else {
              return Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      dictionaryIcons[item!.infoThree],
                      color: ColorApp.mainColor,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.infoOne != null && item.infoOne != '' ? item.infoOne! : 'No info',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: ColorApp.grey1,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            item.infoTwo != '' && item.infoTwo != null ? item.infoTwo! : 'No info',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ).toList(),
      ),
    );
  }
}
