import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/components/image_picker.dart';
import 'package:motors_app/core/constants/preferences_name.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/styles/text_styles.dart';
import 'package:motors_app/data/models/user/user_response.dart';
import 'package:motors_app/presentation/bloc/navigation/navigation_bloc.dart';
import 'package:motors_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:motors_app/presentation/screens/add_car/components/add_car_provider.dart';
import 'package:motors_app/presentation/screens/add_car/components/image_picker_service.dart';
import 'package:motors_app/presentation/screens/home_root.dart';
import 'package:motors_app/presentation/screens/profile/widgets/favourites_widget.dart';
import 'package:motors_app/presentation/screens/profile/widgets/header_widget.dart';
import 'package:motors_app/presentation/screens/profile/widgets/inventory_widget.dart';
import 'package:motors_app/presentation/widgets/alert_dialog.dart';
import 'package:motors_app/presentation/widgets/app_bar_icon.dart';
import 'package:motors_app/presentation/widgets/error_custom_widget.dart';
import 'package:motors_app/presentation/widgets/flutter_toast.dart';
import 'package:motors_app/presentation/widgets/loader_widget.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const String routeName = 'profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userId = preferences.getString(PreferencesName.userId);

  @override
  void initState() {
    if (BlocProvider.of<ProfileBloc>(context).state is! LoadedProfileState) {
      BlocProvider.of<ProfileBloc>(context).add(LoadProfileEvent(userId));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'user_profile'.tr(),
          style: kAppBarStyle,
        ),
        actions: [
          AppBarIcon(
            iconData: Icons.logout,
            onTap: () {
              showBaseDialog(
                context,
                title: 'quit'.tr(),
                content: 'are_you_sure_to_quit'.tr(),
                onPressed: () {
                  Provider.of<AddCarProvider>(context, listen: false).addCarMap.clear();
                  Provider.of<AddCarProvider>(context, listen: false).addCarImageMap?.clear();
                  Provider.of<ImagePickerProvider>(context, listen: false).deleteAllImage();
                  Provider.of<ImagePickerService>(context, listen: false).clearImages();
                  PreferencesName.clearPreferences();

                  Navigator.of(context).pop();

                  BlocProvider.of<NavigationBloc>(context).add(
                    ChangeNavigationEvent(NavbarItem.home, 0),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is SuccessDeleteCarState) {
            showFlutterToast(
              title: 'car_deleted'.tr(),
            ).then((value) {
              Navigator.of(context).pop();

              BlocProvider.of<ProfileBloc>(context).add(LoadProfileEvent(userId));
            });
          }

          if (state is ErrorDeleteCarState) {
            showFlutterToast(
              title: state.message ?? 'Error delete car',
            ).then((value) {
              Navigator.of(context).pop();

              BlocProvider.of<ProfileBloc>(context).add(LoadProfileEvent(userId));
            });
          }

          if (state is LoadedEditCarState) {
            state.response.forEach((key, value) {
              if (key == 'car_location') {
                Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                  type: 'stm_location_text',
                  element: value,
                );
              }

              if (key == 'car_lat') {
                Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                  type: 'stm_lat',
                  element: value,
                );
              }

              if (key == 'car_lng') {
                Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                  type: 'stm_lng',
                  element: value,
                );
              }

              if (key == 'price') {
                Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                  type: 'stm_car_price',
                  element: value,
                );
              }

              if (key == 'features') {
                List<String> _featuresList = [];

                if (value.isNotEmpty) {
                  (value as Map).forEach((key, value) {
                    _featuresList.add(value);
                  });

                  Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                    type: 'stm_additional_features[]',
                    element: _featuresList,
                  );
                }
              }

              if (key == 'gallery') {
                for (var element in value) {
                  Provider.of<ImagePickerService>(context, listen: false).addImageNetworkToList(
                    element['src'],
                  );

                  Provider.of<AddCarProvider>(context, listen: false).addCarImageParams(
                    type: 'add_media',
                    element: Provider.of<ImagePickerService>(context, listen: false).listImages,
                  );
                }
              }
            });

            BlocProvider.of<NavigationBloc>(context).add(
              ChangeNavigationEvent(
                NavbarItem.addCar,
                1,
                editDataArg: EditDataArg(
                  isEdit: true,
                  postId: state.response['ID'],
                  data: state.response,
                ),
              ),
            );
          }

          if (state is SuccessRemoveFromFavCarState) {
            BlocProvider.of<ProfileBloc>(context).add(LoadProfileEvent(userId));
          }

          if (state is ErrorRemoveFromFavCarState) {
            showFlutterToast(
              title: state.message ?? 'Error remove car',
            ).then((value) {
              Navigator.of(context).pop();

              BlocProvider.of<ProfileBloc>(context).add(LoadProfileEvent(userId));
            });
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is InitialProfileState) {
              return const LoaderWidget();
            }

            if (state is LoadingProfileState) {
              return const LoaderWidget();
            }

            if (state is LoadedProfileState) {
              UserInfoResponse userInfo = state.userInfo;

              return RefreshIndicator(
                onRefresh: () async => BlocProvider.of<ProfileBloc>(context).add(LoadProfileEvent(userId)),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Header
                          HeaderWidget(author: userInfo.author),
                          Text(
                            'my_inventory'.tr(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          // MY INVENTORY
                          const Divider(
                            endIndent: 25,
                            indent: 25,
                            thickness: 0.5,
                            color: Colors.black,
                          ),
                          InventoryWidget(
                            listings: userInfo.listings,
                          ),
                          const SizedBox(height: 40),
                          // MY FAVOURITES
                          Text(
                            'my_favourites'.tr(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const Divider(
                            endIndent: 25,
                            indent: 25,
                            thickness: 0.5,
                            color: Colors.black,
                          ),
                          FavouritesWidget(
                            favourites: userInfo.favourites,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            if (state is ErrorProfileState) {
              return ErrorCustomWidget(
                errorMsg: state.message ?? 'Error with Server, try again',
                onTap: () async => BlocProvider.of<ProfileBloc>(context).add(LoadProfileEvent(userId)),
              );
            }

            return LoaderWidget();
          },
        ),
      ),
    );
  }
}
