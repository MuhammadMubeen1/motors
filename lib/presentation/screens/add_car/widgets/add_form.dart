import 'package:flutter/material.dart';
import 'package:motors_app/presentation/screens/add_car/components/add_car_provider.dart';
import 'package:motors_app/presentation/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class AddFormBlock extends StatefulWidget {
  AddFormBlock({
    Key? key,
    required this.title,
    required this.hintText,
    required this.typeForApi,
    this.controller,
    this.keyboardType,
    this.priceIsEmpty = false,
    this.validator,
  }) : super(key: key);

  final String title;
  final String typeForApi;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String hintText;
  final bool priceIsEmpty;
  final FormFieldValidator<String>? validator;

  @override
  State<AddFormBlock> createState() => _AddFormBlockState();
}

class _AddFormBlockState extends State<AddFormBlock> {
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    // This is done this way because sometimes the value comes in this format:
    // "engine": {"1-0": "1.0"}
    // Therefore, in the first condition there is such code, in the other case it comes
    // "engine": "1.0"
    if (Provider.of<AddCarProvider>(context, listen: false).addCarMap.containsKey(widget.typeForApi)) {
      if (Provider.of<AddCarProvider>(context, listen: false).addCarMap[widget.typeForApi] is Map) {
        _textController.text = (Provider.of<AddCarProvider>(context, listen: false).addCarMap[widget.typeForApi] as Map).values.toString().substring(
              1,
              (Provider.of<AddCarProvider>(context, listen: false).addCarMap[widget.typeForApi] as Map).values.toString().length - 1,
            );
      } else {
        _textController.text = Provider.of<AddCarProvider>(context, listen: false).addCarMap[widget.typeForApi];
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 16,
              color: widget.priceIsEmpty ? Colors.red : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 30),
        Expanded(
          flex: 2,
          child: CustomTextField(
            controller: _textController,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            hintText: widget.hintText,
            onChanged: (val) {
              Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                type: widget.typeForApi,
                element: val,
              );
            },
          ),
        ),
      ],
    );
  }
}
