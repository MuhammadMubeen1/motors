import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:motors_app/core/components/location_service.dart';
import 'package:motors_app/presentation/screens/add_car/components/add_car_provider.dart';
import 'package:motors_app/presentation/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class LocationBlock extends StatefulWidget {
  const LocationBlock({super.key, required this.typeForApi});

  final String typeForApi;

  @override
  State<LocationBlock> createState() => _LocationBlockState();
}

class _LocationBlockState extends State<LocationBlock> {
  final _locationController = TextEditingController();
  List<Placemark>? locations = [];
  bool _isHide = true;

  Future<void> getUserLocation() async {
    Provider.of<LocationService>(context, listen: false).getCurrentPosition().then((value) async {
      if (Provider.of<LocationService>(context, listen: false).position != null) {
        locations = await placemarkFromCoordinates(
          Provider.of<LocationService>(context, listen: false).position!.latitude,
          Provider.of<LocationService>(context, listen: false).position!.longitude,
        );

        _locationController.text = '${locations?.first.country ?? ''} ${locations?.first.administrativeArea ?? ''}';

        Provider.of<AddCarProvider>(context, listen: false).addCarParams(
          type: widget.typeForApi,
          element: _locationController.text,
        );

        Provider.of<AddCarProvider>(context, listen: false).addCarParams(
          type: 'stm_lat',
          element: Provider.of<LocationService>(context, listen: false).position!.latitude,
        );
        Provider.of<AddCarProvider>(context, listen: false).addCarParams(
          type: 'stm_lng',
          element: Provider.of<LocationService>(context, listen: false).position!.longitude,
        );
        Provider.of<AddCarProvider>(context, listen: false).addCarParams(
          type: 'stm_location_text',
          element: _locationController.text,
        );
      }
    });
  }

  @override
  void initState() {
    getUserLocation();
    super.initState();
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'location'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 30),
            Expanded(
              flex: 2,
              child: CustomTextField(
                controller: _locationController,
                onChanged: (String? val) async {
                  if (val?.length == 0) {
                    setState(() {
                      _isHide = true;
                    });
                  } else {
                    setState(() {
                      _isHide = false;
                    });

                    Provider.of<AddCarProvider>(context, listen: false).searchPlaces(search: val);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        for (var element in Provider.of<AddCarProvider>(context, listen: false).placeSearchResponse?.predictions ?? [])
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  setState(() {
                    _locationController.text = element['description'];
                    _isHide = true;
                  });

                  List<Location> locationDecode = await locationFromAddress(element['description']);

                  Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                    type: widget.typeForApi,
                    element: element['description'],
                  );
                  Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                    type: 'stm_lat',
                    element: locationDecode[0].latitude,
                  );
                  Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                    type: 'stm_lng',
                    element: locationDecode[0].longitude,
                  );
                  Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                    type: 'stm_location_text',
                    element: element['description'],
                  );
                },
                child: Visibility(
                  visible: _isHide ? false : true,
                  child: Text(
                    element['description'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _isHide ? false : true,
                child: const Divider(thickness: 0.5),
              ),
            ],
          ),
      ],
    );
  }
}
