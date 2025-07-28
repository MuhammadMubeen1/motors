import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/data/models/car_detail/car_detail_response.dart';
import 'package:motors_app/presentation/screens/car_detail/widgets/images_slider/screens/preview_screen.dart';
import 'package:motors_app/presentation/screens/car_detail/widgets/images_slider/screens/video_player_screen.dart';

class VideoWidget extends StatelessWidget {
  const VideoWidget({
    super.key,
    required this.videoLink,
    required this.videoCount,
    required this.videoLinks,
  });

  final String? videoLink;
  final int videoCount;
  final List<VideoLinks?> videoLinks;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 5,
      child: InkWell(
        onTap: () {
          if (videoCount == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(
                  url: videoLink.toString(),
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PreviewScreen(
                  videoLinks: videoLinks,
                ),
              ),
            );
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(color: Colors.black38, blurRadius: .0),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
            child: Row(
              children: [
                Icon(
                  IconsMotors.video,
                  size: 13,
                  color: Colors.white,
                ),
                const SizedBox(width: 8.0),
                Text(
                  '${videoCount} ${'video'.tr().toUpperCase()}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
