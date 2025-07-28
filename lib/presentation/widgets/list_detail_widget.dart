import 'package:flutter/material.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/app_color.dart';

/// This widget is used when adding a car and when searching
class ListDetailWidget extends StatelessWidget {
  const ListDetailWidget({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.title,
    this.count,
  });

  final VoidCallback onTap;
  final bool isSelected;
  final String title;

  /// This params used only in search screen
  /// We show how many cars available
  final int? count;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: isSelected ? ColorApp.mainColor : const Color(0xffe9eef0),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: ColorApp.secondaryColor,
              ),
            ),
            isSelected
                ? Icon(
                    IconsMotors.check,
                    color: ColorApp.mainColor,
                    size: 18,
                  )
                : count != null
                    ? Text(
                        '${count ?? 0}',
                        style: TextStyle(
                          fontSize: 15,
                          color: ColorApp.grey1,
                        ),
                      )
                    : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
