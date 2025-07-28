import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/app_color.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/data/models/app_settings/app_settings_response.dart';
import 'package:motors_app/presentation/bloc/navigation/navigation_bloc.dart';
import 'package:motors_app/presentation/screens/add_car/add_car_screen.dart';
import 'package:motors_app/presentation/screens/auth/sign_in_screen.dart';
import 'package:motors_app/presentation/screens/home/home_screen.dart';
import 'package:motors_app/presentation/screens/profile/profile_screen.dart';
import 'package:motors_app/presentation/screens/search/search_screen.dart';

class EditDataArg {
  EditDataArg({
    required this.isEdit,
    required this.postId,
    required this.data,
  });

  final bool isEdit;
  final String postId;
  final Map<String, dynamic> data;
}

class HomeRoot extends StatelessWidget {
  const HomeRoot({super.key});

  static const String routeName = 'homeRoot';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          if (state is NavigationChangedState) {
            if (state.navbarItem == NavbarItem.home) {
              return HomeScreen();
            } else if (state.navbarItem == NavbarItem.addCar && appType != AppType.dealership) {
              return AddCarScreen(editDataArg: state.editDataArg);
            } else if (state.navbarItem == NavbarItem.search) {
              return SearchScreen();
            } else if (state.navbarItem == NavbarItem.profile) {
              return ProfileScreen();
            }
          }

          if (state is NavigationNotAuthState) {
            return SignInScreen();
          }

          return const SizedBox();
        },
      ),
      bottomNavigationBar: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          if (state is NavigationChangedState) {
            return BottomNavigationBar(
              selectedItemColor: ColorApp.mainColor,
              unselectedItemColor: ColorApp.grey1,
              currentIndex: state.index,
              onTap: (int? index) {
                if (!isAuth() && ((appType == AppType.dealership ? index == 2 : index == 1) || (appType == AppType.dealership ? index == 2 : index == 3))) {
                  BlocProvider.of<NavigationBloc>(context).add(
                    ChangeNavigationEvent(NavbarItem.notAuth, 5),
                  );

                  return;
                }

                if (appType == AppType.dealership) {
                  if (index == 0) {
                    BlocProvider.of<NavigationBloc>(context).add(
                      ChangeNavigationEvent(NavbarItem.home, 0),
                    );
                  } else if (index == 1) {
                    BlocProvider.of<NavigationBloc>(context).add(
                      ChangeNavigationEvent(NavbarItem.search, 1),
                    );
                  } else if (index == 2) {
                    BlocProvider.of<NavigationBloc>(context).add(
                      ChangeNavigationEvent(NavbarItem.profile, 2),
                    );
                  }
                } else {
                  if (index == 0) {
                    BlocProvider.of<NavigationBloc>(context).add(
                      ChangeNavigationEvent(NavbarItem.home, 0),
                    );
                  } else if (index == 1 && appType != AppType.dealership) {
                    BlocProvider.of<NavigationBloc>(context).add(
                      ChangeNavigationEvent(NavbarItem.addCar, 1),
                    );
                  } else if (index == 2) {
                    BlocProvider.of<NavigationBloc>(context).add(
                      ChangeNavigationEvent(NavbarItem.search, 2),
                    );
                  } else if (index == 3) {
                    BlocProvider.of<NavigationBloc>(context).add(
                      ChangeNavigationEvent(NavbarItem.profile, 3),
                    );
                  }
                }
              },
              selectedFontSize: 0,
              items: [
               BottomNavigationBarItem(
                
                  icon: ImageIcon(AssetImage('assets/images/home_icon.png'), size: 30 ,),
                  label: '',
                  tooltip: 'Home',
                ),
                if (appType != AppType.dealership)
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage('assets/images/add_icon.png'),
                        size: 30),
                    label: '',
                    tooltip: 'Add Car',
                  ),
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('assets/images/search_icon.png'),
                      size: 30),
                  label: '',
                  tooltip: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconsMotors.person, size: 30),
                  label: '',
                  tooltip: 'Profile',
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
