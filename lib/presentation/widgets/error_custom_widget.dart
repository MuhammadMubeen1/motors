import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/core/styles/app_color.dart';
import 'package:motors_app/presentation/widgets/app_elevated_button.dart';

class ErrorCustomWidget extends StatelessWidget {
  const ErrorCustomWidget({
    super.key,
    required this.errorMsg,
    this.onTap,
  });

  final String? errorMsg;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'error'.tr(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              errorMsg ?? 'error'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: ColorApp.grey1,
              ),
            ),
            const SizedBox(height: 10),
            AppElevatedButton.secondary(
              onPressed: onTap,
              child: Text('try_again'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
