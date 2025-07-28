import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/presentation/screens/add_car/components/add_car_provider.dart';
import 'package:motors_app/presentation/screens/add_car/screens/add_car_detail_screen.dart';
import 'package:provider/provider.dart';

class OtherTypeWidget extends StatefulWidget {
  const OtherTypeWidget({
    super.key,
    this.element,
    required this.typeForApi,
    this.errorColor = false,
  });

  final dynamic element;
  final String typeForApi;
  final bool? errorColor;

  @override
  State<OtherTypeWidget> createState() => _OtherTypeWidgetState();
}

class _OtherTypeWidgetState extends State<OtherTypeWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.element.value.runtimeType == List) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCarDetailScreen(
                typeOfParams: widget.element.key,
                typeForApi: widget.typeForApi,
                data: widget.element.value,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCarDetailScreen(
                typeForApi: widget.typeForApi,
                typeOfParams: widget.element.key,
                data: const [],
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.element.key}'.tr().toUpperCase(),
              style: TextStyle(
                fontSize: 16,
                color: widget.errorColor! && !Provider.of<AddCarProvider>(context).addCarMap.containsKey('${widget.typeForApi}${widget.element.key}') ? Colors.red : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                if (Provider.of<AddCarProvider>(context).addCarMap.containsKey('${widget.typeForApi}${widget.element.key}'))
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                          border: Border.all(width: 1, color: const Color(0xffe9eef0)),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Text(
                              Provider.of<AddCarProvider>(context).addCarMap['${widget.typeForApi}${widget.element.key}'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                Provider.of<AddCarProvider>(context, listen: false).removeCarParams(
                                  type: '${widget.typeForApi}${widget.element.key}',
                                );
                              },
                              child: const Icon(IconsMotors.close, size: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    'choose'.tr(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.all(3.5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey,
                    size: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
