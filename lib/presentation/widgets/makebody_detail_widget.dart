import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/core/styles/app_color.dart';

class MakeBodyDetailWidget extends StatelessWidget {
  const MakeBodyDetailWidget({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.logo,
    required this.title,
  });

  final VoidCallback onTap;
  final bool isSelected;
  final String logo;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 200,
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: isSelected ? ColorApp.mainColor : Colors.white,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: logo,
              errorWidget: (BuildContext context, String url, dynamic error) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
