import 'dart:io';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/app_color.dart';
import 'package:motors_app/core/styles/text_styles.dart';
import 'package:motors_app/presentation/screens/add_car/components/add_car_provider.dart';
import 'package:motors_app/presentation/screens/add_car/components/image_picker_service.dart';
import 'package:motors_app/presentation/widgets/app_bar_icon.dart';
import 'package:motors_app/presentation/widgets/app_elevated_button.dart';
import 'package:provider/provider.dart';

class AddMediaScreen extends StatefulWidget {
  const AddMediaScreen({Key? key}) : super(key: key);

  static const String routeName = 'add/media/car';

  @override
  State<AddMediaScreen> createState() => _AddMediaScreenState();
}

class _AddMediaScreenState extends State<AddMediaScreen> {
  late ImagePickerService imageProvider;
  late ImagePickerService imageProviderMethod;

  @override
  Widget build(BuildContext context) {
    imageProvider = Provider.of<ImagePickerService>(context);
    imageProviderMethod = Provider.of<ImagePickerService>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xff252525),
      appBar: AppBar(
        backgroundColor: const Color(0xff252525),
        leading: AppBarIcon(
          iconData: IconsMotors.arrow_back,
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
            if (imageProvider.listImages.isNotEmpty)
              Expanded(
                child: ReorderableListView.builder(
                  proxyDecorator: proxyDecorator,
                  buildDefaultDragHandles: true,
                  itemCount: imageProvider.listImages.length,
                  onReorder: (int oldIndex, int newIndex) {
                    if (oldIndex < newIndex) {
                      int end = newIndex - 1;
                      File startItem = imageProvider.listImages[oldIndex];
                      int i = 0;
                      int local = oldIndex;

                      do {
                        imageProvider.listImages[local] = imageProvider.listImages[++local];
                        i++;
                      } while (i < end - oldIndex);
                      imageProvider.listImages[end] = startItem;
                    } else if (oldIndex > newIndex) {
                      File startItem = imageProvider.listImages[oldIndex];
                      for (int i = oldIndex; i > newIndex; i--) {
                        imageProvider.listImages[i] = imageProvider.listImages[i - 1];
                      }
                      imageProvider.listImages[newIndex] = startItem;
                    }

                    setState(() {});
                  },
                  itemBuilder: (BuildContext context, int index) {
                    final item = imageProvider.listImages[index];

                    return GestureDetector(
                      key: Key('$item'),
                      onTap: () {
                        if (imageProvider.listImages.isEmpty) {
                          imageProviderMethod.pickImages();
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: ColorApp.grey1,
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              child: Image.file(
                                File(item.path.toString()),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () => imageProviderMethod.deleteImage(item),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              GestureDetector(
                onTap: () async {
                  imageProviderMethod.pickImages();
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
                  height: 200,
                  decoration: const BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: ColorApp.grey1,
                  ),
                  child: const Center(
                    child: Icon(
                      IconsMotors.add,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            Visibility(
              visible: imageProvider.listImages.isEmpty,
              child: const Spacer(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 10),
                    child: AppElevatedButton.secondary(
                      onPressed: () async => imageProviderMethod.pickImages(),
                      child: Text('choose_photo'.tr()),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15, bottom: 10),
                    child: AppElevatedButton.secondary(
                      onPressed: () async => imageProviderMethod.openCamera(),
                      child: Text('open_camera'.tr()),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(right: 15, left: 15, bottom: 20),
              child: AppElevatedButton.primary(
                onPressed: () {
                  Provider.of<AddCarProvider>(context, listen: false).addCarImageParams(
                    type: 'add_media',
                    element: imageProvider.listImages,
                  );

                  Navigator.of(context).pop();
                },
                child: Text('save'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 6, animValue)!;
        return Material(
          elevation: elevation,
          color: Colors.transparent,
          shadowColor: Colors.black.withOpacity(0.5),
          child: child,
        );
      },
      child: child,
    );
  }
}
