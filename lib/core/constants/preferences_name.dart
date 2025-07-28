import 'package:motors_app/core/env.dart';

class PreferencesName {
  /// User api token when he auth
  static const String apiToken = 'apiToken';

  /// Every user have unique ID
  static const String userId = 'userId';

  /// Field password for [EditProfileScreen]
  static const String password = 'password';

  static void clearPreferences() {
    preferences.remove(apiToken);
    preferences.remove(userId);
    preferences.remove(password);
  }
}
