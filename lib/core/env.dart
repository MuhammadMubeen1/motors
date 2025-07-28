import 'package:image_picker/image_picker.dart';
import 'package:motors_app/data/models/app_settings/app_settings_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App Environments
late AppType appType;
String inventoryType = '';
String currency = '\$';
String currencyName = 'USD';
String? logo;
String googleApiToken = '';

// List for filter
Set<dynamic> filteredListForSearch = {};

// Local Storage
late SharedPreferences preferences;

// ImagePicker
final ImagePicker picker = ImagePicker();
