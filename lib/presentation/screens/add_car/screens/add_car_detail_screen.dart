import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/text_styles.dart';
import 'package:motors_app/presentation/screens/add_car/components/add_car_provider.dart';
import 'package:motors_app/presentation/widgets/app_bar_icon.dart';
import 'package:motors_app/presentation/widgets/list_detail_widget.dart';
import 'package:motors_app/presentation/widgets/makebody_detail_widget.dart';
import 'package:provider/provider.dart';

class AddCarDetailScreen extends StatefulWidget {
  AddCarDetailScreen({
    Key? key,
    required this.typeOfParams,
    this.data,
    this.typeForApi,
  }) : super(key: key);

  final String typeOfParams;
  final String? typeForApi;
  final List<dynamic>? data;

  @override
  State<AddCarDetailScreen> createState() => _AddCarDetailScreenState();
}

class _AddCarDetailScreenState extends State<AddCarDetailScreen> {
  List<dynamic>? _filteredList = [];

  Future<void> filterList() async {
    if (widget.typeOfParams == 'serie') {
      for (var element in widget.data!) {
        if (Provider.of<AddCarProvider>(context, listen: false).addCarMap.containsKey('${widget.typeForApi}make')) {
          if (element['parent'] == Provider.of<AddCarProvider>(context, listen: false).addCarMap['${widget.typeForApi}make'].toString().toLowerCase()) {
            setState(() {
              _filteredList?.add(element);
            });
          }
        }
      }
    } else if (widget.typeOfParams == 'trim') {
      for (var element in widget.data!) {
        if (Provider.of<AddCarProvider>(context, listen: false).addCarMap.containsKey('${widget.typeForApi}make')) {
          if (element['parent'] == Provider.of<AddCarProvider>(context, listen: false).addCarMap['${widget.typeForApi}make'].toString().toLowerCase()) {
            setState(() {
              _filteredList?.add(element);
            });
          }
        }
      }
    } else {
      _filteredList = widget.data;
    }
  }

  @override
  void initState() {
    filterList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.typeOfParams == 'make'
              ? 'choose_make'.tr()
              : widget.typeOfParams == 'serie'
                  ? 'choose_model'.tr()
                  : widget.typeOfParams == 'year'
                      ? '${'choose'.tr()} ${'year'.tr()}'
                      : widget.typeOfParams == 'exterior-color'
                          ? '${'choose'.tr()} ${'exterior-color'.tr()}'
                          : 'choose'.tr(),
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
              Expanded(
                child: widget.typeOfParams == 'make' || widget.typeOfParams == 'body'
                    ? AlignedGridView.count(
                        itemCount: _filteredList?.length,
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        itemBuilder: (context, index) {
                          final item = _filteredList?[index];

                          bool isSelected = false;

                          if (Provider.of<AddCarProvider>(context, listen: false).addCarMap.containsKey('${widget.typeForApi}${widget.typeOfParams}')) {
                            if (Provider.of<AddCarProvider>(context, listen: false).addCarMap['${widget.typeForApi}${widget.typeOfParams}'] == item['label']) {
                              isSelected = true;
                            }
                          }

                          return MakeBodyDetailWidget(
                            logo: item['logo'],
                            title: item['label'],
                            isSelected: isSelected,
                            onTap: () {
                              Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                                type: '${widget.typeForApi}${widget.typeOfParams}',
                                element: item['label'],
                              );

                              Navigator.of(context).pop();
                            },
                          );
                        },
                      )
                    : ListView.builder(
                        primary: true,
                        key: UniqueKey(),
                        itemCount: _filteredList?.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          final item = _filteredList?[index];

                          bool isSelected = false;

                          if (Provider.of<AddCarProvider>(context, listen: false).addCarMap.containsKey('${widget.typeForApi}${widget.typeOfParams}')) {
                            if (Provider.of<AddCarProvider>(context, listen: false).addCarMap['${widget.typeForApi}${widget.typeOfParams}'] == item['label']) {
                              isSelected = true;
                            }
                          }

                          return ListDetailWidget(
                            title: item['label'],
                            isSelected: isSelected,
                            onTap: () {
                              Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                                type: '${widget.typeForApi}${widget.typeOfParams}',
                                element: item['label'],
                              );

                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
