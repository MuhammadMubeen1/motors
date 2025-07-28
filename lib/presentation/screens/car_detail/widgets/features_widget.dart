import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/app_color.dart';
import 'package:motors_app/data/models/car_detail/car_detail_response.dart';

class FeaturesWidget extends StatefulWidget {
  const FeaturesWidget({
    Key? key,
    required this.carDetailResponse,
  }) : super(key: key);

  final CarDetailResponse carDetailResponse;

  @override
  State<FeaturesWidget> createState() => _FeaturesWidgetState();
}

class _FeaturesWidgetState extends State<FeaturesWidget> {
  bool _isExpandedFeatures = false;

  @override
  Widget build(BuildContext context) {
    if (widget.carDetailResponse.features == null || widget.carDetailResponse.features!.isEmpty) {
      return const SizedBox();
    }

    return ExpansionPanelList(
      elevation: 0,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isExpandedFeatures = isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          isExpanded: _isExpandedFeatures,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, top: 12.5),
              child: Text(
                'features'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
          body: Wrap(
            children: widget.carDetailResponse.features!
                .map(
                  (item) => Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    margin: const EdgeInsets.only(right: 15, bottom: 20, left: 15),
                    child: Wrap(
                      children: [
                        Icon(
                          IconsMotors.iconComplete,
                          color: ColorApp.mainColor,
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          item ?? '',
                          style: const TextStyle(
                            color: Color(0xff616161),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
