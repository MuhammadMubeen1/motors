import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/text_styles.dart';
import 'package:motors_app/presentation/bloc/add_car/add_car_bloc.dart';
import 'package:motors_app/presentation/bloc/navigation/navigation_bloc.dart';
import 'package:motors_app/presentation/screens/add_car/components/add_car_provider.dart';
import 'package:motors_app/presentation/screens/add_car/components/image_picker_service.dart';
import 'package:motors_app/presentation/screens/add_car/screens/step_2_screen.dart';
import 'package:motors_app/presentation/screens/add_car/widgets/add_form.dart';
import 'package:motors_app/presentation/screens/add_car/widgets/add_media_widget.dart';
import 'package:motors_app/presentation/screens/add_car/widgets/features_widget.dart';
import 'package:motors_app/presentation/screens/add_car/widgets/location_widget.dart';
import 'package:motors_app/presentation/screens/add_car/widgets/other_type_widget.dart';
import 'package:motors_app/presentation/screens/add_car/widgets/seller_note_widget.dart';
import 'package:motors_app/presentation/screens/home_root.dart';
import 'package:motors_app/presentation/widgets/app_bar_icon.dart';
import 'package:motors_app/presentation/widgets/app_elevated_button.dart';
import 'package:motors_app/presentation/widgets/error_custom_widget.dart';
import 'package:motors_app/presentation/widgets/loader_widget.dart';
import 'package:provider/provider.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({
    Key? key,
    this.editDataArg,
  }) : super(key: key);

  final EditDataArg? editDataArg;

  static const String routeName = 'add/car/first';

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  bool errorColor = false;
  bool priceIsEmpty = false;

  @override
  void initState() {
    _putDataFromEditing();

    BlocProvider.of<AddCarBloc>(context).add(LoadAddCarParamsEvent());
    super.initState();
  }

  void _putDataFromEditing() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.editDataArg != null) {
        widget.editDataArg?.data.forEach((key, value) {
          if (key == 'info') {
            value.forEach((key, value) {
              if (key == 'step_one') {
                value.forEach((key, value) {
                  if (value != null && value != '') {
                    if (key != 'add_media' && key != 'price' && key != 'location' && key != 'features' && key != 'fuel-consumption' && key != 'mileage' && key != 'seller_notes' && key != 'engine') {
                      Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                        type: 'stm_f_s_$key',
                        element: value.values.toString().substring(1, value.values.toString().length - 1),
                      );
                    }

                    if (key == 'price') {
                      Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                        type: 'stm_car_price',
                        element: value,
                      );
                    }

                    if (key == 'engine') {
                      Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                        type: 'stm_f_s_engine',
                        element: value,
                      );
                    }

                    if (key == 'mileage') {
                      Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                        type: 'stm_f_s_mileage',
                        element: value,
                      );
                    }

                    if (key == 'fuel_consumptions') {
                      Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                        type: 'stm_f_s_fuel_consumptions',
                        element: value,
                      );
                    }

                    if (key == 'seller_notes') {
                      Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                        type: 'stm_seller_notes',
                        element: value,
                      );
                    }
                  }
                });
              }
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBarIcon(
          iconData: IconsMotors.arrow_back,
          onTap: () {
            // Delete added images
            Provider.of<ImagePickerService>(context, listen: false).clearImages();
            // Delete added params of car
            Provider.of<AddCarProvider>(context, listen: false).addCarMap.clear();
            // Delete added param images of car
            Provider.of<AddCarProvider>(context, listen: false).addCarImageMap?.clear();

            BlocProvider.of<NavigationBloc>(context).add(
              ChangeNavigationEvent(
                NavbarItem.home,
                0,
              ),
            );
          },
        ),
        title: Column(
          children: [
            Text(
              'build_your_ad'.tr(),
              style: kAppBarStyle,
            ),
            Text(
              'step_1'.tr(),
              style: kAppBarSubtitleStyle,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<AddCarBloc, AddCarState>(
          builder: (context, state) {
            if (state is LoadedAddCarParamsState) {
              final Map item = state.addCarResponse?.stepOne;

              return SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(20.0),
                  child: Column(
                    children: item.entries
                        .map(
                          (element) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Add Media
                              if (element.key == 'add_media')
                                AddMediaBlock()
                              else if (element.key == 'engine')
                                AddFormBlock(
                                  title: 'engine'.tr(),
                                  typeForApi: 'stm_f_s_engine',
                                  hintText: 'engine',
                                )
                              else if (element.key == 'location')
                                LocationBlock(typeForApi: 'stm_f_s_location')
                              else if (element.key == 'price')
                                AddFormBlock(
                                  title: '${'price'.tr().toUpperCase()}*',
                                  hintText: '$currency $currencyName',
                                  typeForApi: 'stm_car_price',
                                  keyboardType: TextInputType.number,
                                  priceIsEmpty: priceIsEmpty,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'fill_the_form'.tr();
                                    }

                                    return null;
                                  },
                                )
                              else if (element.key == 'mileage')
                                AddFormBlock(
                                  title: 'mileage'.tr(),
                                  hintText: 'km'.tr(),
                                  typeForApi: 'stm_f_s_mileage',
                                  keyboardType: TextInputType.number,
                                )
                              else if (element.key == 'fuel-consumption')
                                AddFormBlock(
                                  title: 'fuel-consumption'.tr(),
                                  typeForApi: 'stm_f_s_fuel_consumptions',
                                  hintText: 'fuel-consumption'.tr(),
                                )
                              else if (element.key == 'seller_notes')
                                SellerNoteBlock()
                              else if (element.key == 'stm_additional_features')
                                FeaturesBlock(data: element.value)
                              else if (element.value.runtimeType != List)
                                const SizedBox()
                              else
                                OtherTypeWidget(
                                  element: element,
                                  typeForApi: 'stm_f_s_',
                                  errorColor: errorColor,
                                ),
                              Visibility(
                                visible: element.key == 'add_media' ? false : true,
                                child: const Divider(),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            }

            if (state is ErrorAddCarParamsState) {
              return ErrorCustomWidget(
                errorMsg: state.message ?? 'Error get car params',
              );
            }

            return const LoaderWidget();
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<AddCarBloc, AddCarState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: AppElevatedButton.secondary(
              onPressed: () {
                if (state is LoadedAddCarParamsState) {
                  Map item = state.addCarResponse?.stepOne;

                  item.forEach((key, value) {
                    if (!Provider.of<AddCarProvider>(context, listen: false).addCarMap.containsKey('stm_f_s_$key')) {
                      setState(() {
                        errorColor = true;
                      });
                    } else {
                      setState(() {
                        errorColor = false;
                      });
                    }
                  });
                }

                if (!errorColor) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StepTwoScreen(
                        editDataArg: widget.editDataArg,
                      ),
                    ),
                  );
                }
              },
              child: Text('next_step'.tr()),
            ),
          );
        },
      ),
    );
  }
}
