import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/presentation/screens/add_car/components/add_car_provider.dart';
import 'package:motors_app/presentation/screens/add_car/components/image_picker_service.dart';
import 'package:motors_app/presentation/screens/add_car/screens/add_media_screen.dart';
import 'package:provider/provider.dart';

class AddMediaBlock extends StatelessWidget {
  const AddMediaBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'add_media'.tr().toUpperCase(),
          style: TextStyle(
            fontSize: 16,
            color: Provider.of<AddCarProvider>(context, listen: false).isValidate ? Colors.red : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddMediaScreen(),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Provider.of<ImagePickerService>(context).listImages.isEmpty
                ? const Center(
                    child: Icon(
                      IconsMotors.addPhoto,
                      color: Colors.grey,
                      size: 30,
                    ),
                  )
                : ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Image.file(
                      File(Provider.of<ImagePickerService>(context).listImages[0].path.toString()),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
