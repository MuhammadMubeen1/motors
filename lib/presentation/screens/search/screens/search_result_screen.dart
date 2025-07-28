import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/text_styles.dart';
import 'package:motors_app/presentation/bloc/filter_result/filter_result_bloc.dart';
import 'package:motors_app/presentation/screens/car_detail/car_detail_screen.dart';
import 'package:motors_app/presentation/widgets/app_bar_icon.dart';
import 'package:motors_app/presentation/widgets/grid_car_widget.dart';
import 'package:motors_app/presentation/widgets/list_car_widget.dart';
import 'package:motors_app/presentation/widgets/loader_widget.dart';
class SearchResultScreen extends StatelessWidget {
  const SearchResultScreen({
    Key? key,
    this.filters,
    this.min_price,
    this.max_price,
    this.min_year,
    this.max_year,
    this.search_radius,
  }) : super(key: key);

  static const String routeName = 'searchResultScreen';

  final dynamic filters;
  final dynamic min_price;
  final dynamic max_price;
  final dynamic min_year;
  final dynamic max_year;
  final dynamic search_radius;

  @override
  Widget build(BuildContext context) {
    // Ensure filters are properly passed to the bloc
    return BlocProvider(
      create: (context) => FilterResultBloc()
        ..add(
          AddToFilterEvent(
            limit: -1,
            condition: filters ?? {}, // Handle null safely
            min_price: min_price,
            max_price: max_price,
            min_year: min_year,
            max_year: max_year,
            search_radius: search_radius,
          ),
        ),
      child: Scaffold(
        appBar: AppBar(
          leading: AppBarIcon(
            iconData: IconsMotors.arrow_back,
            onTap: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'search_result'.tr(),
            style: kAppBarStyle,
          ),
        ),
        body: BlocBuilder<FilterResultBloc, FilterState>(
          builder: (context, state) {
            if (state is InitialFilterListingState) {
              return const LoaderWidget();
            }

            if (state is LoadedFilteredListingsState) {
              return SafeArea(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: state.listings.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(thickness: 1.5),
                  itemBuilder: (BuildContext context, int index) {
                    final item = state.listings[index];

                    if (inventoryType == 'inventory_view_grid') {
                      return GridCarWidget(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarDetailScreen(
                              idCar: item.ID,
                            ),
                          ),
                        ),
                        item: item,
                      );
                    } else {
                      return ListCarWidget(
                        onTap: () =>
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarDetailScreen(
                              idCar: item.ID,
                            ),
                          ),
                        ),
                        item: item,
                      );
                    }
                  },
                ),
              );
            }

            if (state is EmptyFilteredListingState) {
              return Center(
                child: Text('filter_is_empty'.tr()),
              );
            }

            return Center(
              child: Text('error'.tr()),
            );
          },
        ),
        bottomNavigationBar: const SizedBox(height: 0),
      ),
    );
  }
}
