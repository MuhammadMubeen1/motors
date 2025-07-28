import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/core/components/image_picker.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/app_color.dart';
import 'package:motors_app/core/styles/text_styles.dart';
import 'package:motors_app/presentation/widgets/app_bar_icon.dart';
import 'package:motors_app/presentation/widgets/app_elevated_button.dart';
import 'package:provider/provider.dart';

class ImageDetailScreen extends StatelessWidget {
  const ImageDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImagePickerProvider imageProvider = Provider.of<ImagePickerProvider>(context);

    ImagePickerProvider imageProviderMethod = Provider.of<ImagePickerProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xff252525),
      appBar: AppBar(
        backgroundColor: const Color(0xff252525),
        leading: AppBarIcon(
          iconColor: Colors.white,
          borderColor: Colors.white,
          onTap: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'choose_image'.tr(),
          style: kAppBarWhiteStyle,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async => imageProviderMethod.pickImg(),
                    child: Container(
                      margin: const EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        color: ColorApp.grey1,
                      ),
                      child: imageProvider.image != null
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  child: Image.file(
                                    File(imageProvider.image!.path.toString()),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    onPressed: () => imageProviderMethod.deleteImg(),
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const Center(
                              child: Icon(
                                IconsMotors.add,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AppElevatedButton.secondary(
                      onPressed: () => imageProviderMethod.pickImg(),
                      child: Text('choose_photo'.tr()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppElevatedButton.secondary(
                      onPressed: () async => imageProviderMethod.openCamera(),
                      child: Text('open_camera'.tr()),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 15, left: 15, bottom: 20),
              child: AppElevatedButton.primary(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('save'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
