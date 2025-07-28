import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/app_color.dart';
import 'package:motors_app/data/models/car_detail/car_detail_response.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({
    Key? key,
    required this.carDetailResponse,
    this.latitude,
    this.longitude,
    this.marker,
  }) : super(key: key);

  final CarDetailResponse carDetailResponse;
  final double? latitude;
  final double? longitude;
  final Set<Marker>? marker;

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  final Completer<GoogleMapController> _controller = Completer();
  bool _isExpandedLocation = false;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.carDetailResponse.carLocation.isEmpty ? false : true,
      child: ExpansionPanelList(
        elevation: 0,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpandedLocation = isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: _isExpandedLocation,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: [
                    Icon(IconsMotors.locationMarkFill, color: ColorApp.secondaryColor),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'location'.tr(),
                              style: TextStyle(
                                color: ColorApp.grey88,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              widget.carDetailResponse.carLocation,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            body: SizedBox(
              height: 200,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.latitude!, widget.longitude!),
                  zoom: 14.4746,
                ),
                onMapCreated: (GoogleMapController controller) async {
                  if (!_controller.isCompleted) {
                    _controller.complete(controller);
                  } else {
                    log('Load completer');
                  }
                },
                gestureRecognizers: Set()..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
                markers: widget.marker!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
