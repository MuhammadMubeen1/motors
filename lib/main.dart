import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/components/image_picker.dart';
import 'package:motors_app/core/components/location_service.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/services/localization_service.dart';
import 'package:motors_app/core/services/network_service.dart';
import 'package:motors_app/core/styles/app_theme.dart';
import 'package:motors_app/presentation/bloc/add_car/add_car_bloc.dart';
import 'package:motors_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:motors_app/presentation/bloc/bloc_observer.dart';
import 'package:motors_app/presentation/bloc/filter/filter_bloc.dart';
import 'package:motors_app/presentation/bloc/home/home_bloc.dart';
import 'package:motors_app/presentation/bloc/navigation/navigation_bloc.dart';
import 'package:motors_app/presentation/bloc/network_handler/network_bloc.dart';
import 'package:motors_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:motors_app/presentation/screens/add_car/add_car_screen.dart';
import 'package:motors_app/presentation/screens/add_car/components/add_car_provider.dart';
import 'package:motors_app/presentation/screens/add_car/components/image_picker_service.dart';
import 'package:motors_app/presentation/screens/home_root.dart';
import 'package:motors_app/presentation/screens/profile/profile_screen.dart';
import 'package:motors_app/presentation/screens/search/components/search_filter_provider.dart';
import 'package:motors_app/presentation/screens/search/search_screen.dart';
import 'package:motors_app/presentation/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  Bloc.observer = SimpleBlocObserver();

  preferences = await SharedPreferences.getInstance();

  runApp(
    EasyLocalization(
      fallbackLocale: Locale('en'),
      supportedLocales: const [Locale('en')],
      startLocale: const Locale('en'),
      useOnlyLangCode: true,
      path: 'assets/translations/',
      assetLoader: LocalizationService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocProvider(
        create: (context) => NavigationBloc(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (BuildContext context) => AuthBloc(),
            ),
            BlocProvider<ProfileBloc>(
              create: (BuildContext context) => ProfileBloc(),
            ),
            BlocProvider<FilterBloc>(
              create: (BuildContext context) => FilterBloc(),
            ),
            BlocProvider<HomeBloc>(
              create: (BuildContext context) => HomeBloc(),
            ),
            BlocProvider<AddCarBloc>(
              create: (BuildContext context) => AddCarBloc(),
            ),
            BlocProvider<NetworkBloc>(
              create: (BuildContext context) => NetworkBloc()..add(NetworkObserveEvent()),
            ),
          ],
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider<ImagePickerProvider>(create: (context) => ImagePickerProvider()),
              ChangeNotifierProvider<ImagePickerService>(create: (context) => ImagePickerService()),
              ChangeNotifierProvider<AddCarProvider>(create: (context) => AddCarProvider()),
              ChangeNotifierProvider<LocationService>(create: (context) => LocationService()),
              ChangeNotifierProvider<SearchFilterProvider>(create: (context) => SearchFilterProvider()),
            ],
            child: MaterialApp(
              navigatorKey: navigatorKey,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              title: 'Motors App',
              debugShowCheckedModeBanner: false,
              theme: AppTheme().themeLight,
              initialRoute: SplashScreen.routeName,
              builder: (context, child) {
                return NetworkService(child: child!);
              },
              onGenerateRoute: (settings) {
                WidgetBuilder builder;
                switch (settings.name) {
                  case SplashScreen.routeName:
                    builder = (_) => SplashScreen();
                    break;
                  case HomeRoot.routeName:
                    builder = (_) => HomeRoot();
                    break;
                  case AddCarScreen.routeName:
                    builder = (_) => AddCarScreen();
                    break;
                  case SearchScreen.routeName:
                    builder = (_) => SearchScreen();
                    break;
                  case ProfileScreen.routeName:
                    builder = (_) => ProfileScreen();
                    break;
                  default:
                    throw Exception('Invalid route: ${settings.name}');
                }
                return MaterialPageRoute(builder: builder, settings: settings);
              },
            ),
          ),
        ),
      ),
    );
  }
}
