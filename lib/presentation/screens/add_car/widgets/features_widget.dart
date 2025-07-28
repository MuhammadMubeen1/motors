import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/core/styles/app_color.dart';
import 'package:motors_app/presentation/screens/add_car/components/add_car_provider.dart';
import 'package:provider/provider.dart';

class FeaturesBlock extends StatefulWidget {
  const FeaturesBlock({super.key, required this.data});

  final List<dynamic> data;

  @override
  State<FeaturesBlock> createState() => _FeaturesWidgetState();
}

class _FeaturesWidgetState extends State<FeaturesBlock> {
  List<String> _featuresList = [];

  @override
  void initState() {
    if (Provider.of<AddCarProvider>(context, listen: false).addCarMap.containsKey('stm_additional_features[]')) {
      _featuresList = Provider.of<AddCarProvider>(context, listen: false).addCarMap['stm_additional_features[]'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'select_your_car_features'.tr().toUpperCase(),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          for (var element in widget.data)
            GestureDetector(
              onTap: () {
                if (_featuresList.contains(element['label'])) {
                  setState(() {
                    _featuresList.remove(element['label']);
                  });
                } else {
                  setState(() {
                    _featuresList.add(element['label']);
                  });
                }

                Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                  type: 'stm_additional_features[]',
                  element: _featuresList,
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: _featuresList.contains(element['label']) ? 2 : 1.5,
                    color: _featuresList.contains(element['label']) ? ColorApp.mainColor : const Color(0xffe9eef0),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      element['label'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      _featuresList.contains(element['label']) ? Icons.check_circle : Icons.circle,
                      color: _featuresList.contains(element['label']) ? ColorApp.mainColor : const Color(0xffe9eef0),
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
