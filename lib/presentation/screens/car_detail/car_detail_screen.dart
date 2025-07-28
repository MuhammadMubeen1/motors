import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/constants/preferences_name.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/app_color.dart';
import 'package:motors_app/core/styles/text_styles.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/presentation/bloc/car_detail/car_detail_bloc.dart';
import 'package:motors_app/presentation/bloc/navigation/navigation_bloc.dart';
import 'package:motors_app/presentation/screens/car_detail/widgets/author_widget.dart';
import 'package:motors_app/presentation/screens/car_detail/widgets/car_info_widget.dart';
import 'package:motors_app/presentation/screens/car_detail/widgets/comment_widget.dart';
import 'package:motors_app/presentation/screens/car_detail/widgets/fav_icon_widget.dart';
import 'package:motors_app/presentation/screens/car_detail/widgets/features_widget.dart';
import 'package:motors_app/presentation/screens/car_detail/widgets/images_slider/image_slider_widget.dart';
import 'package:motors_app/presentation/screens/car_detail/widgets/location_widget.dart';
import 'package:motors_app/presentation/screens/home_root.dart';
import 'package:motors_app/presentation/widgets/app_bar_icon.dart';
import 'package:motors_app/presentation/widgets/error_custom_widget.dart';
import 'package:motors_app/presentation/widgets/loader_widget.dart';
import 'package:motors_app/presentation/widgets/recommended_widget.dart';

class CarDetailScreen extends StatefulWidget {
  const CarDetailScreen({
    Key? key,
    required this.idCar,
    this.fromAddCar = false,
  }) : super(key: key);

  static const String routeName = 'car/detail';

  final  idCar;
  final bool fromAddCar;

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  String? userId = preferences.getString(PreferencesName.userId);
  String? userToken = preferences.getString(PreferencesName.apiToken);

  @override
  void initState() {
    super.initState();
    // Verify the car ID is valid
    if (widget.idCar <= 0) {
      Future.microtask(() {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid car ID')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CarDetailBloc()
        ..add(
          CarDetailLoadEvent(
            id: widget.idCar,
            userId: userId != null ? int.tryParse(userId!) : null,
          ),
        ),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: BlocBuilder<CarDetailBloc, CarDetailState>(
            builder: (context, state) {
              return AppBar(
                leading: AppBarIcon(
                  iconData: IconsMotors.arrow_back,
                  onTap: () {
                    if (widget.fromAddCar) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeRoot(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                      BlocProvider.of<NavigationBloc>(context).add(
                        ChangeNavigationEvent(NavbarItem.home, 0),
                      );
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                title: state is LoadedCarDetailState
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            state.loadedDetailCar.subTitle ?? '',
                            style: kAppBarStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            state.loadedDetailCar.title ?? '',
                            style: kAppBarSubtitleStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )
                    : const SizedBox(),
                actions: [
                  if (state is LoadedCarDetailState)
                    if (isAuth())
                      FavIconWidget(
                        inFavorites: state.loadedDetailCar.inFavorites ?? false,
                        carId: state.loadedDetailCar.id ?? 0,
                      ),
                ],
              );
            },
          ),
        ),
        body: BlocBuilder<CarDetailBloc, CarDetailState>(
          builder: (context, state) {
            if (state is InitialCarDetailState ||
                state is LoadingCarDetailState) {
              return const LoaderWidget();
            }

            if (state is LoadedCarDetailState) {
              final item = state.loadedDetailCar;
              if (item.id == null) {
                return ErrorCustomWidget(
                  errorMsg: 'Invalid car data',
                  onTap: () => BlocProvider.of<CarDetailBloc>(context).add(
                    CarDetailLoadEvent(
                      id: widget.idCar,
                      userId: userId != null ? int.tryParse(userId!) : null,
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    if (item.gallery != null)
                      ImageSliderWidget(carDetailResponse: item),
                    CarInfoWidget(carDetailResponse: item),
                    Divider(
                        thickness: 1.5, color: ColorApp.mainColor, height: 0),
                    FeaturesWidget(carDetailResponse: item),
                    const Divider(
                        thickness: 0.2, color: ColorApp.grey1, height: 0),
                    AuthorWidget(carDetailResponse: item),
                    Divider(
                        thickness: 1.5, color: ColorApp.mainColor, height: 0),
                    CommentWidget(carDetailResponse: item),
                    Divider(
                        thickness: 1.5, color: ColorApp.mainColor, height: 0),
                    // LocationWidget(
                    //   carDetailResponse: item,
                    //   latitude: state.latitude,
                    //   longitude: state.longitude,
                    //   marker: state.marker,
                    // ),
                    Divider(
                        thickness: 1.5, color: ColorApp.mainColor, height: 0),
                    if (item.similar != null && item.similar!.isNotEmpty)
                      RecommendedWidget(featuredItem: item.similar!),
                  ].where((widget) => widget != null).toList(),
                ),
              );
            }

            if (state is ErrorCarDetailState) {
              return ErrorCustomWidget(
                errorMsg: state.message ?? 'Failed to load car details',
                onTap: () => BlocProvider.of<CarDetailBloc>(context).add(
                  CarDetailLoadEvent(
                    id: widget.idCar,
                    userId: userId != null ? int.tryParse(userId!) : null,
                  ),
                ),
              );
            }

            return ErrorCustomWidget(
              errorMsg: 'Unknown state encountered',
              onTap: () => BlocProvider.of<CarDetailBloc>(context).add(
                CarDetailLoadEvent(
                  id: widget.idCar,
                  userId: userId != null ? int.tryParse(userId!) : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
