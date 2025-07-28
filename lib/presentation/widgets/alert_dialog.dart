import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Base AlertDialog based platform (Android or IOS)
Future<T?> showBaseDialog<T>(
  BuildContext context, {
  bool barrierDismissible = false,
  bool scrollable = false,
  required String title,
  required String content,
  String? cancelText,
  String? submitText,
  VoidCallback? onPressed,
  VoidCallback? onCancel,
}) {
  return showDialog<T?>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      if (Platform.isAndroid) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: onCancel ?? () => Navigator.of(context).pop(),
              child: Text(
                cancelText ?? 'cancel'.tr(),
                style: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
            ),
            TextButton(
              onPressed: onPressed ?? () => Navigator.of(context).pop(),
              child: Text(
                submitText ?? 'ok'.tr(),
                style: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        );
      } else {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: onCancel ?? () => Navigator.of(context).pop(),
              child: Text(cancelText ?? 'cancel'.tr()),
            ),
            TextButton(
              onPressed: onPressed ?? () => Navigator.of(context).pop(),
              child: Text(submitText ?? 'ok'.tr()),
            ),
          ],
        );
      }
    },
  );
}
