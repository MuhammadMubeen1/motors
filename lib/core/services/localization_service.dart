import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motors_app/core/services/http_service.dart';
import 'package:motors_app/core/utils/logger.dart';

class LocalizationService extends AssetLoader {
  LocalizationService();

  Map<String, dynamic> translationMap = {};

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    try {
      final response = await HttpService().dio.get('/settings');

      // Handle translations from API
      dynamic translationsData = response.data['translations'];

      Map<String, dynamic> remoteLocal;

      // If translationsData is a String, decode it
      if (translationsData is String) {
        remoteLocal = jsonDecode(translationsData) as Map<String, dynamic>;
      }
      // If it's already a Map, use it directly
      else if (translationsData is Map<String, dynamic>) {
        remoteLocal = translationsData;
      }
      // If it's neither, fallback to local JSON
      else {
        throw Exception('Invalid translations format');
      }

      // Load local translations as fallback
      String localJsonString =
          await rootBundle.loadString('assets/translations/en.json');
      Map<String, dynamic> localTranslations =
          jsonDecode(localJsonString) as Map<String, dynamic>;

      // Merge remote and local translations (local acts as fallback)
      localTranslations.forEach((key, value) {
        if (!remoteLocal.containsKey(key)) {
          remoteLocal[key] = value;
        }
      });

      return remoteLocal;
    } on DioException catch (e, s) {
      logger.e('Error with load localization - /settings',
          error: e, stackTrace: s);

      // Fallback to local JSON if API fails
      String localJsonString =
          await rootBundle.loadString('assets/translations/en.json');
      return jsonDecode(localJsonString) as Map<String, dynamic>;
    } catch (e, s) {
      logger.e('Unexpected error in LocalizationService',
          error: e, stackTrace: s);

      // Final fallback
      String localJsonString =
          await rootBundle.loadString('assets/translations/en.json');
      return jsonDecode(localJsonString) as Map<String, dynamic>;
    }
  }
}
