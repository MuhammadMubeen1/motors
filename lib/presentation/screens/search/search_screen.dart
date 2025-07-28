import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/app_color.dart';
import 'package:motors_app/core/styles/text_styles.dart';
import 'package:motors_app/presentation/bloc/filter/filter_bloc.dart';
import 'package:motors_app/presentation/screens/search/components/search_filter_provider.dart';
import 'package:motors_app/presentation/screens/search/screens/search_detail_screen.dart';
import 'package:motors_app/presentation/screens/search/screens/search_result_screen.dart';
import 'package:motors_app/presentation/screens/search/widgets/price_range_widget.dart';
import 'package:motors_app/presentation/screens/search/widgets/year_widget.dart';
import 'package:motors_app/presentation/widgets/app_elevated_button.dart';
import 'package:motors_app/presentation/widgets/error_custom_widget.dart';
import 'package:motors_app/presentation/widgets/loader_widget.dart';
import 'package:motors_app/presentation/widgets/recommended_widget.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  static const String routeName = 'searchScreen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();

  double sliderKm = 1000;
  double minValue = 1000;
  double maxValue = 15000;
  double minRadius = 1000;
  var mToKm;

  @override
  void initState() {
    if (BlocProvider.of<FilterBloc>(context).state is! LoadedFilterState) {
      BlocProvider.of<FilterBloc>(context).add(LoadFilterEvent());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'filter'.tr(),
          style: kAppBarStyle,
        ),
      ),
      body: BlocBuilder<FilterBloc, FilterState>(
        builder: (context, state) {
          if (state is InitialFilterState) {
            return const LoaderWidget();
          }

          if (state is LoadedFilterState) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var element in state.filter)
                        for (var key in element.keys) _widgetBuildFilter(element, key),
                      _buildSearchButton(state),
                      if (state.featuredResponse.isNotEmpty) RecommendedWidget(featuredItem: state.featuredResponse),
                    ],
                  ),
                ),
              ),
            );
          }

          if (state is ErrorFilterState) {
            return SingleChildScrollView(
              child: ErrorCustomWidget(
                errorMsg: state.message ?? 'error'.tr(),
              ),
            );
          }

          return Center(
            child: Text('error'.tr()),
          );
        },
      ),
    );
  }

  Widget _widgetBuildFilter(element, String key) {
    if (key == '') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 104.0),
        child: Center(
          child: Text(
            'search_currently_not_working'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    } else {
      return Column(
        children: [
          InkWell(
            onTap: key == 'year' || key == 'price' || key == 'search_radius'
                ? null
                : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchDetailScreen(
                          typeSearch: element[key],
                          typeKey: key,
                        ),
                      ),
                    ),
            child: Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      key.tr().toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SFProDisplay-Bold',
                        fontSize: 17,
                      ),
                    ),
                  ),
                  if (key == 'year')
                    YearWidget(
                      typeKey: key,
                      element: element,
                    )
                  else if (key == 'price')
                    PriceRangeWidget(
                      minPriceController: _minPriceController,
                      maxPriceController: _maxPriceController,
                    )
                  else if (key == 'search_radius')
                    _buildSearchRadius()
                  else
                    Row(
                      children: [
                        // Selected Type
                        if (Provider.of<SearchFilterProvider>(context).selectedSearchFilterList.containsKey(key))
                          Column(
                            children: [
                              for (var el in Provider.of<SearchFilterProvider>(context).selectedSearchFilterList[key]!)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                                    border: Border.all(width: 1, color: const Color(0xffe9eef0)),
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.only(right: 10, top: 7),
                                  child: Row(
                                    children: [
                                      Text(
                                        el['label'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () => Provider.of<SearchFilterProvider>(context, listen: false).removeElement(
                                          typeKey: key,
                                          el: el,
                                        ),
                                        child: const Icon(IconsMotors.close, size: 15),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        const SizedBox(width: 15),
                        // Navigate Icon
                        DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300,
                          ),
                          child: GestureDetector(
                            onTap: () async => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchDetailScreen(
                                  typeSearch: element[key],
                                  typeKey: key,
                                ),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.only(left: 8.0, right: 8, top: 8, bottom: 8),
                              child: Icon(
                                IconsMotors.arrowIos,
                                color: Colors.grey,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const Divider(thickness: 0.5, height: 0, color: Colors.grey),
        ],
      );
    }
  }

  Widget _buildSearchRadius() => Slider(
        value: sliderKm,
        min: minValue,
        max: maxValue,
        divisions: 7,
        inactiveColor: Colors.black,
        activeColor: Colors.redAccent,
        thumbColor: ColorApp.mainColor,
        label: '${sliderKm / 1000}km',
        onChanged: (values) {
          setState(() {
            sliderKm = values;
            minRadius = values;
            var minRadiusForApi = values;
            mToKm = minRadiusForApi / 1000;
          });
        },
      );

  Widget _buildSearchButton(LoadedFilterState state) {
    bool isDisabled = false;

    for (var element in state.filter) {
      for (var elementOne in element.keys) {
        if (elementOne == '') {
          isDisabled = true;
        }
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: AppElevatedButton.primary(
        onPressed: isDisabled
            ? null
            : () async {
                if (_formKey.currentState!.validate()) {
                  for (var element in state.filter) {
                    element.forEach((key, value) {
                      if (Provider.of<SearchFilterProvider>(context, listen: false).selectedSearchFilterList.containsKey(key)) {
                        for (var i = 0; i < Provider.of<SearchFilterProvider>(context, listen: false).selectedSearchFilterList[key]!.length; i++) {
                          filteredListForSearch.add({'$key[$i]': Provider.of<SearchFilterProvider>(context, listen: false).selectedSearchFilterList[key]![i]['slug']});
                        }
                      }
                    });
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchResultScreen(
                        filters: filteredListForSearch,
                        min_price: _minPriceController.text == '' ? 0 : _minPriceController.text,
                        max_price: _maxPriceController.text == '' ? 0 : _maxPriceController.text,
                        min_year: Provider.of<SearchFilterProvider>(context, listen: false).from,
                        max_year: Provider.of<SearchFilterProvider>(context, listen: false).to,
                        search_radius: mToKm,
                      ),
                    ),
                  ).then(
                    (value) => setState(() {
                      Provider.of<SearchFilterProvider>(context, listen: false).setValueTo = 'to'.tr();
                      Provider.of<SearchFilterProvider>(context, listen: false).setValueFrom = 'from'.tr();
                      _minPriceController.clear();
                      _maxPriceController.clear();
                      filteredListForSearch;
                    }),
                  );
                }
              },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              IconsMotors.searchLight,
              size: 15,
            ),
            const SizedBox(width: 5),
            Text(
              'vehicles'.tr(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
