import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/app_color.dart';
import 'package:motors_app/data/models/user/user_response.dart';
import 'package:motors_app/presentation/screens/edit_profile/edit_profile_screen.dart';
import 'package:motors_app/presentation/widgets/app_elevated_button.dart';
import 'package:motors_app/presentation/widgets/loader_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key, required this.author}) : super(key: key);

  final Author author;

  String get fullName => '${author.name} ${author.lastName}';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              child: CachedNetworkImage(
                width: double.infinity,
                height: double.infinity,
                imageUrl: '${author.image}',
                fit: BoxFit.cover,
                placeholder: (context, url) => LoaderWidget(
                  loaderColor: Colors.white,
                ),
                errorWidget: (context, url, error) => Image(
                  image: AssetImage('assets/images/avatar.png'),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          fullName,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 35,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent.withOpacity(0),
              side: BorderSide(
                width: 1,
                color: ColorApp.secondaryColor,
              ),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfileScreen(
                  author: author,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.edit,
                  size: 18,
                  color: ColorApp.secondaryColor,
                ),
                const SizedBox(width: 5),
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: ColorApp.secondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 35),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: author.phone == null || author.phone == '' ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
            children: [
              if (author.phone != null && author.phone != '')
                Flexible(
                  child: AppElevatedButton.secondary(
                    onPressed: () async {
                      final Uri launchUri = Uri(scheme: 'tel', path: author.phone);

                      if (await canLaunchUrl(launchUri)) {
                        await launchUrl(launchUri);
                      } else {
                        throw 'Could not launch $launchUri';
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(IconsMotors.phone, size: 15),
                        const SizedBox(width: 5),
                        Text(
                          author.phone ?? 'No info',
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(width: 10),
              Flexible(
                child: AppElevatedButton.white(
                  onPressed: () async {
                    if (author.phone != null && author.phone != '') {
                      final Uri launchUri = Uri(scheme: 'sms', path: author.phone);

                      await launchUrl(launchUri);
                    } else {
                      final Uri launchUri = Uri(scheme: 'mailto', path: author.email);

                      await launchUrl(launchUri);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        IconsMotors.message,
                        size: 15,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'send_message'.tr(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
