import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/constants/preferences_name.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/data/datasources/car_detail_datasource.dart';
import 'package:motors_app/presentation/bloc/car_detail/favourite_car/favourite_car_bloc.dart';
import 'package:motors_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:motors_app/presentation/widgets/app_bar_icon.dart';
import 'package:motors_app/presentation/widgets/flutter_toast.dart';

class FavIconWidget extends StatefulWidget {
  const FavIconWidget({
    super.key,
    required this.inFavorites,
    required this.carId,
  });

  /// Variables from API [true/false]
  final bool inFavorites;
  final int carId;

  @override
  State<FavIconWidget> createState() => _FavIconWidgetState();
}

class _FavIconWidgetState extends State<FavIconWidget> {
  bool _isFav = false;

  @override
  void initState() {
    if (widget.inFavorites) {
      _isFav = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavouriteCarBloc(),
      child: BlocListener<FavouriteCarBloc, FavouriteCarState>(
        listener: (context, state) {
          if (state is ErrorFavouriteCarState) {
            _isFav = state.oldValue;

            showFlutterToast(title: state.message ?? 'Error with favourite func');
          }

          if (state is SuccessFavouriteCarState) {
            BlocProvider.of<ProfileBloc>(context).add(
              LoadProfileEvent(preferences.getString(PreferencesName.userId)),
            );
          }
        },
        child: BlocBuilder<FavouriteCarBloc, FavouriteCarState>(
          builder: (context, state) {
            return AppBarIcon(
              iconData: Icons.favorite,
              iconColor: _isFav ? Colors.red : null,
              onTap: state is LoadingFavouriteCarState
                  ? null
                  : () {
                      if (_isFav) {
                        setState(() {
                          _isFav = false;
                        });

                        BlocProvider.of<FavouriteCarBloc>(context).add(
                          AddToFavouriteEvent(
                            carId: widget.carId,
                            action: FavouriteActions.remove,
                          ),
                        );
                      } else {
                        setState(() {
                          _isFav = true;
                        });

                        BlocProvider.of<FavouriteCarBloc>(context).add(
                          AddToFavouriteEvent(
                            carId: widget.carId,
                            action: FavouriteActions.add,
                          ),
                        );
                      }

                      BlocProvider.of<ProfileBloc>(context).add(
                        LoadProfileEvent(
                          preferences.getString(PreferencesName.userId),
                        ),
                      );
                    },
            );
          },
        ),
      ),
    );
  }
}
