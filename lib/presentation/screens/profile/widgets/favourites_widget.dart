import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/styles/app_color.dart';
import 'package:motors_app/data/models/base_models/base_car_response.dart';
import 'package:motors_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:motors_app/presentation/screens/car_detail/car_detail_screen.dart';
import 'package:motors_app/presentation/widgets/list_car_widget.dart';

class FavouritesWidget extends StatefulWidget {
  const FavouritesWidget({super.key, this.favourites});

  final List<BaseCarDetailResponse>? favourites;

  @override
  State<FavouritesWidget> createState() => _FavouritesWidgetState();
}

class _FavouritesWidgetState extends State<FavouritesWidget> {
  List<BaseCarDetailResponse>? _favouritesList = [];

  @override
  void initState() {
    _favouritesList = widget.favourites;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_favouritesList == null || _favouritesList!.isEmpty) {
      return Center(
        child: Text(
          'favourites_empty'.tr(),
          style: TextStyle(
            color: ColorApp.grey1,
            fontSize: 15,
          ),
        ),
      );
    } else {
      return Column(
        children: _favouritesList!
            .map(
              (item) => ListCarWidget(
                item: item,
                removeFromFavorites: () {
                  _favouritesList!.remove(item);

                  BlocProvider.of<ProfileBloc>(context).add(
                    RemoveFavouriteCarEvent(
                      carId: item.ID,
                    ),
                  );
                },
                isFavourite: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarDetailScreen(
                      idCar: item.ID,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      );
    }
  }
}
