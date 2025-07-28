import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/presentation/bloc/splash/splash_bloc.dart';
import 'package:motors_app/presentation/screens/home_root.dart';
import 'package:motors_app/presentation/widgets/flutter_toast.dart';
import 'package:motors_app/presentation/widgets/loader_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  static const String routeName = 'splash';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc()..add(LoadSplashEvent()),
      child: Scaffold(
        drawerScrimColor: Colors.white.withOpacity(0.5),
        backgroundColor: Colors.white,
        body: BlocListener<SplashBloc, SplashState>(
          listener: (context, state) {
            if (state is LoadedSplashState) {
              Future.delayed(
                const Duration(milliseconds: 1000),
                () async {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    HomeRoot.routeName,
                    ModalRoute.withName(HomeRoot.routeName),
                  );
                },
              );
            }

            if (state is ErrorSplashState) {
              showFlutterToast(title: state.message.toString());
            }
          },
          child: BlocBuilder<SplashBloc, SplashState>(
            builder: (context, state) {
              String? logo;
              int? numOfListing;

              if (state is LoadedSplashState) {
                logo = state.appSettings.logo;
                numOfListing = state.appSettings.numOfListings;
              }

              return Stack(
                children: [
                  // White background container
                  Container(
                    color: Colors.white, // This sets the background to white
                  ),

                  // Logo Motors
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: SafeArea(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: CachedNetworkImage(
                          filterQuality: FilterQuality.high,
                          imageUrl: logo.toString() ?? '',
                          width: 200,
                          height: 200,
                          placeholder: (context, url) {
                            return const SizedBox(
                              width: 20,
                              height: 20,
                              child: LoaderWidget(),
                            );
                          },
                          errorWidget: (context, url, error) {
                            return Center(
                              child: const Image(
                                image: AssetImage('assets/images/logo_dark.png'),
                                width: 190,
                                height: 150,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  // Count listings
                  Padding(
                    padding: const EdgeInsets.only(bottom: 60.0),
                    child: SafeArea(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (state is InitialSplashState)
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: LoaderWidget(),
                              )
                            else
                              Text(
                                '${numOfListing.toString() ?? '0'}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                            const SizedBox(height: 10),

                            // Text
                            Text(
                              'vehicle_for_sale'.tr().toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
