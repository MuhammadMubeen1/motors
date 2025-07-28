import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/presentation/screens/add_car/components/add_car_provider.dart';
import 'package:provider/provider.dart';

class SellerNoteBlock extends StatefulWidget {
  const SellerNoteBlock({super.key});

  @override
  State<SellerNoteBlock> createState() => _SellerNoteBlockState();
}

class _SellerNoteBlockState extends State<SellerNoteBlock> {
  TextEditingController _sellerNoteController = TextEditingController();

  @override
  void initState() {
    if (Provider.of<AddCarProvider>(context, listen: false).addCarMap.containsKey('stm_seller_notes')) {
      _sellerNoteController.text = Provider.of<AddCarProvider>(context, listen: false).addCarMap['stm_seller_notes'];
    }
    super.initState();
  }

  @override
  void dispose() {
    _sellerNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'seller_note'.tr().toUpperCase(),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          TextFormField(
            onChanged: (val) {
              Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                type: 'stm_seller_notes',
                element: _sellerNoteController.text,
              );
            },
            controller: _sellerNoteController,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'Enter a text ...',
              fillColor: const Color(0xffe9eef0),
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(width: 0, color: Colors.white),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
