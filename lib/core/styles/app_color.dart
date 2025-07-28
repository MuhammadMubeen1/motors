import 'package:flutter/material.dart';
import 'package:motors_app/core/extensions/color_extensions.dart';

class ColorApp {
  static Color mainColor = const Color(0xff1bc744);
  static Color secondaryColor = const Color(0xff2d60f3);
  static const Color grey88 = const Color(0xff888888);
  static const Color grey1 = const Color(0xffacacac);
  static const Color white = const Color(0xffffffff);

  void setMainColor(String color) {
    mainColor = HexColor.fromHex(color);
  }

  void setSecondaryColor(String color) {
    secondaryColor = HexColor.fromHex(color);
  }
}
