import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/presentation/widgets/loader_widget.dart';

class CachedNetworkCustomImage extends StatelessWidget {
  const CachedNetworkCustomImage({
    super.key,
    required this.imgUrl,
  });

  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: double.infinity,
      imageUrl: imgUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => const LoaderWidget(
        loaderColor: Colors.white,
      ),
      errorWidget: (context, url, error) => Image(
        image: AssetImage('assets/images/avatar.png'),
      ),
    );
  }
}
