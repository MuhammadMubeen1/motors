import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/app_color.dart';
import 'package:motors_app/data/models/car_detail/car_detail_response.dart';
import 'package:motors_app/presentation/screens/car_detail/widgets/images_slider/screens/video_player_screen.dart';
import 'package:motors_app/presentation/widgets/app_bar_icon.dart';
import 'package:motors_app/presentation/widgets/loader_widget.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';


class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key, required this.videoLinks});

  final List<VideoLinks?> videoLinks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text('video'.tr()),
        leading: AppBarIcon(
          iconData: IconsMotors.arrow_back,
          onTap: () => Navigator.of(context).pop(),
          borderColor: Colors.white,
          iconColor: Colors.white,
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: videoLinks.length,
          itemBuilder: (BuildContext context, int index) {
            final item = videoLinks[index];
            String? videoId;
            if (item?.videoLink != null) {
              videoId = convertUrlToId(item!.videoLink);
            }

            String thumbnailUrl = getThumbnail(videoId: videoId ?? '');

            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    url: item?.videoLink.toString()??'',
                  ),
                ),
              ),
              child: Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: CachedNetworkImage(
                        fit: BoxFit.contain,
                        imageUrl: item?.video_posters ?? thumbnailUrl,
                        placeholder: (context, url) => const Center(
                          child: LoaderWidget(
                            loaderColor: Colors.white,
                          ),
                        ),
                        errorWidget: (context, url, error) => Image(
                          image: AssetImage('assets/images/placeholder_car.png'),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: ColorApp.secondaryColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
    if (!url.contains('http') && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(r'''
^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$'''),
      RegExp(r'''
^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$'''),
      RegExp(r'''
^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$'''),
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return null;
  }

  String getThumbnail({
    required String videoId,
    String quality = ThumbnailQuality.standard,
    bool webp = true,
  }) =>
      webp ? 'https://i3.ytimg.com/vi_webp/$videoId/$quality.webp' : 'https://i3.ytimg.com/vi/$videoId/$quality.jpg';
}
