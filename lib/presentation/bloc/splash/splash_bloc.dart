import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/styles/app_color.dart';
import 'package:motors_app/core/utils/logger.dart';
import 'package:motors_app/data/models/app_settings/app_settings_response.dart';
import 'package:motors_app/data/repositories/app_settings_repository.dart';
part 'splash_event.dart';
part 'splash_state.dart';


class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(InitialSplashState()) {
    on<LoadSplashEvent>((event, emit) async {
      try {
        final appSettings = await appSettingsRepository.getAppSettings();

        /// Set Environments
        appType = appSettings.appType;
        inventoryType = appSettings.inventoryView;
        ColorApp().setMainColor(appSettings.mainColor);
        ColorApp().setSecondaryColor(appSettings.secondaryColor);
        currency = appSettings.currency;
        currencyName = appSettings.currencyName;
        googleApiToken = appSettings.apiKeyAndroid;
        logo = appSettings.logo;

        emit(LoadedSplashState(appSettings));
      } catch (e, s) {
        logger.e('Error with method getAppSettings - SplashBloc', error: e, stackTrace: s);
        emit(ErrorSplashState(e.toString()));
      }
    });
  }

  final AppSettingsRepository appSettingsRepository = AppSettingsRepositoryImpl();
}
