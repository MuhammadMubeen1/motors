import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/app_color.dart';
import 'package:motors_app/data/models/car_detail/car_detail_response.dart';
import 'package:motors_app/presentation/screens/dealer_profile/dealer_profile_screen.dart';
import 'package:motors_app/presentation/widgets/app_elevated_button.dart';
import 'package:motors_app/presentation/widgets/cached_image_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthorWidget extends StatelessWidget {
  const AuthorWidget({Key? key, required this.carDetailResponse}) : super(key: key);

  final CarDetailResponse carDetailResponse;

  @override
  Widget build(BuildContext context) {
    final authorResponse = carDetailResponse.author;

    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color(0xffEAEFF1),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => DealerProfile(
                      dealerId: authorResponse.userId.toString(),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: CachedNetworkCustomImage(
                          imgUrl: authorResponse.image ?? '',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authorResponse.name != null && authorResponse.name!.isNotEmpty ? authorResponse.name! : 'seller'.tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          authorResponse.userRole == 'Private Seller' ? 'private_seller'.tr() : authorResponse.userRole!,
                          style: TextStyle(
                            color: ColorApp.grey88,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'added'.tr(),
                    style: TextStyle(
                      color: ColorApp.grey88,
                    ),
                  ),
                  Text(
                    authorResponse.regDate ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 35),
          Row(
            mainAxisAlignment: authorResponse.phone == null || authorResponse.phone == '' ? MainAxisAlignment.center : MainAxisAlignment.spaceAround,
            children: [
              // Phone
              if (authorResponse.phone != null && authorResponse.phone != '')
                Expanded(
                  child: AppElevatedButton.secondary(
                    onPressed: () async {
                      if (authorResponse.phone == null || authorResponse.phone == '') {
                        log('No phone');
                      } else {
                        final Uri launchUri = Uri(scheme: 'tel', path: authorResponse.phone);

                        await launchUrl(launchUri);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(IconsMotors.phone, size: 15),
                        const SizedBox(width: 5),
                        Text(
                          authorResponse.phone ?? '',
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(width: 15),
              // Message
              Expanded(
                child: AppElevatedButton.white(
                  onPressed: () async {
                    if (authorResponse.phone != null && authorResponse.phone != '') {
                      final Uri launchUri = Uri(scheme: 'sms', path: authorResponse.phone);

                      await launchUrl(launchUri);
                    } else {
                      final Uri launchUri = Uri(scheme: 'mailto', path: authorResponse.email);

                      await launchUrl(launchUri);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        IconsMotors.message,
                        size: 15,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          'send_message'.tr(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
