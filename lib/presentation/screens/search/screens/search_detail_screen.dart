import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/app_color.dart';
import 'package:motors_app/core/styles/text_styles.dart';
import 'package:motors_app/presentation/screens/search/components/search_filter_provider.dart';
import 'package:motors_app/presentation/widgets/app_bar_icon.dart';
import 'package:motors_app/presentation/widgets/app_elevated_button.dart';
import 'package:motors_app/presentation/widgets/list_detail_widget.dart';
import 'package:motors_app/presentation/widgets/makebody_detail_widget.dart';
import 'package:provider/provider.dart';

class SearchDetailScreen extends StatefulWidget {
  SearchDetailScreen({
    Key? key,
    this.typeSearch,
    required this.typeKey,
  }) : super(key: key);

  static const String routeName = 'searchDetailScreen';

  final List<dynamic>? typeSearch;

  final String? typeKey;

  @override
  State<SearchDetailScreen> createState() => _SearchDetailScreenState();
}

class _SearchDetailScreenState extends State<SearchDetailScreen> {
  TextEditingController _searchController = TextEditingController();

  String? headerText = '';

  List<dynamic> filteredSearch = [];
  List<dynamic> selectedValue = [];
  List<dynamic>? _filteredList = [];

  Future filterList() async {
    if (widget.typeKey == 'serie') {
      for (var element in widget.typeSearch!) {
        for (var el in Provider.of<SearchFilterProvider>(context, listen: false).selectedSearchFilterList['make']!) {
          if (element['parent'] == el['slug']) {
            _filteredList?.add(element);
          }
        }
      }
    } else if (widget.typeKey == 'trim') {
      for (var element in widget.typeSearch!) {
        for (var el in Provider.of<SearchFilterProvider>(context, listen: false).selectedSearchFilterList['make']!) {
          if (element['parent'] == el['slug']) {
            _filteredList?.add(element);
          }
        }
      }
    } else {
      _filteredList = widget.typeSearch;
    }
  }

  @override
  void initState() {
    if (widget.typeKey != null || widget.typeKey != '') {
      headerText = 'choose_'.tr() + widget.typeKey!;
    }

    filterList();

    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          headerText == null ? 'choose'.tr() : headerText!,
          style: kAppBarStyle,
        ),
        leading: AppBarIcon(
          iconData: IconsMotors.arrow_back,
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            children: [
              // Search Field
              Visibility(
                visible: widget.typeKey == 'make' ? false : true,
                child: SizedBox(
                  height: 45,
                  child: TextFormField(
                    controller: _searchController,
                    onChanged: (val) {
                      for (int i = 0; i < _filteredList!.length; i++) {
                        var data = _filteredList;
                        if (data?[i]['label'].toLowerCase().contains(val.toLowerCase()) || data?[i]['label'].toUpperCase().contains(val.toUpperCase())) {
                          filteredSearch.clear();
                          setState(() {
                            filteredSearch.add(data![i]);
                          });
                        }
                      }

                      if (val.isEmpty) {
                        filteredSearch.clear();
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffe9eef0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0, color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintStyle: TextStyle(color: ColorApp.grey1, fontSize: 13),
                      hintText: 'type_for_search'.tr(),
                    ),
                  ),
                ),
              ),
              // Details
              Expanded(
                child: widget.typeKey == 'make' || widget.typeKey == 'body'
                    ? AlignedGridView.count(
                        itemCount: _filteredList?.length ?? 0,
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        itemBuilder: (context, index) {
                          final item = _filteredList?[index];

                          bool isSelected = false;

                          if (Provider.of<SearchFilterProvider>(context).selectedSearchFilterList.isEmpty) {
                            isSelected = false;
                          } else {
                            if (Provider.of<SearchFilterProvider>(context).selectedSearchFilterList[widget.typeKey] == null) {
                            } else {
                              for (var element in Provider.of<SearchFilterProvider>(context).selectedSearchFilterList[widget.typeKey]!) {
                                if (item['label'] == element['label']) {
                                  isSelected = true;
                                }
                              }
                            }
                          }

                          return MakeBodyDetailWidget(
                            logo: item['logo'],
                            title: item['label'],
                            isSelected: isSelected,
                            onTap: () => Provider.of<SearchFilterProvider>(context, listen: false).selectedFilterValue(
                              typeKey: widget.typeKey,
                              value: item,
                              selectedValue: selectedValue,
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        primary: true,
                        key: UniqueKey(),
                        itemCount: filteredSearch.isNotEmpty ? filteredSearch.length : _filteredList?.length ?? 0,
                        itemBuilder: (BuildContext ctx, int index) {
                          final item;

                          bool isSelected = false;

                          if (filteredSearch.isNotEmpty) {
                            item = filteredSearch[index];
                          } else {
                            item = _filteredList?[index];
                          }

                          if (Provider.of<SearchFilterProvider>(context).selectedSearchFilterList.isEmpty) {
                            isSelected = false;
                          } else {
                            if (Provider.of<SearchFilterProvider>(context).selectedSearchFilterList[widget.typeKey] != null) {
                              for (var element in Provider.of<SearchFilterProvider>(context).selectedSearchFilterList[widget.typeKey]!) {
                                if (item['label'] == element['label']) {
                                  isSelected = true;
                                }
                              }
                            }
                          }

                          return ListDetailWidget(
                            title: item['label'],
                            isSelected: isSelected,
                            count: item['count'],
                            onTap: () => Provider.of<SearchFilterProvider>(context, listen: false).selectedFilterValue(
                              typeKey: widget.typeKey,
                              value: item,
                              selectedValue: selectedValue,
                            ),
                          );
                        },
                      ),
              ),

              Container(
                margin: const EdgeInsets.only(bottom: 10),
                width: double.infinity,
                height: 45,
                child: AppElevatedButton.secondary(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        IconsMotors.searchLight,
                        size: 15,
                      ),
                      const SizedBox(width: 8),
                      Text('choose'.tr()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
