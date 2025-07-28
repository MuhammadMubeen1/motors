import 'package:motors_app/core/constants/preferences_name.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';

Map<String, dynamic> dictionaryIcons = {
  'road': IconsMotors.road,
  'fuel': IconsMotors.fuel,
  'body_type': IconsMotors.body,
  'engine_fill': IconsMotors.engine,
  'transmission_fill': IconsMotors.transmission,
  'drive_2': IconsMotors.drivingType,
  'color_type': IconsMotors.colorExterior,
  'car': IconsMotors.car,
  'calendar': IconsMotors.calendar,
  'pin_big': IconsMotors.marker,
  'gear': IconsMotors.trim,
  'stm-rental-seats': IconsMotors.salonColor,
  'stm-rental-thumbs_rent': IconsMotors.condition,
  'vin': IconsMotors.vin,
  '': null,
};

/// Check user is auth or not
bool isAuth() {
  if (preferences.getString(PreferencesName.apiToken) != null && preferences.getString(PreferencesName.apiToken)!.isNotEmpty) {
    return true;
  }

  return false;
}
