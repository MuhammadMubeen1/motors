import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/presentation/widgets/custom_text_field.dart';

class PriceRangeWidget extends StatefulWidget {
  const PriceRangeWidget({
    Key? key,
    required this.minPriceController,
    required this.maxPriceController,
  }) : super(key: key);

  final TextEditingController minPriceController;
  final TextEditingController maxPriceController;

  @override
  State<PriceRangeWidget> createState() => _PriceRangeWidgetState();
}

class _PriceRangeWidgetState extends State<PriceRangeWidget> {
  @override
  void dispose() {
    widget.maxPriceController.dispose();
    widget.minPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: CustomTextField(
            hintText: 'min'.tr(),
            controller: widget.minPriceController,
            keyboardType: TextInputType.number,
            validator: (val) {
              if (widget.maxPriceController.text != '' && widget.minPriceController.text == '') {
                return 'fill_the_form'.tr();
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 20),
        SizedBox(
          width: 100,
          child: CustomTextField(
            hintText: 'max'.tr(),
            controller: widget.maxPriceController,
            keyboardType: TextInputType.number,
            validator: (val) {
              if (widget.minPriceController.text != '') {
                if (int.parse(widget.maxPriceController.text) < int.parse(widget.minPriceController.text)) {
                  return 'price_error'.tr();
                }
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
