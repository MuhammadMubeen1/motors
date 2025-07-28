import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/constants/preferences_name.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/text_styles.dart';
import 'package:motors_app/presentation/bloc/add_car/add_car_bloc.dart';
import 'package:motors_app/presentation/screens/add_car/components/add_car_provider.dart';
import 'package:motors_app/presentation/screens/add_car/components/image_picker_service.dart';
import 'package:motors_app/presentation/screens/add_car/widgets/add_form.dart';
import 'package:motors_app/presentation/screens/add_car/widgets/add_media_widget.dart';
import 'package:motors_app/presentation/screens/add_car/widgets/features_widget.dart';
import 'package:motors_app/presentation/screens/add_car/widgets/location_widget.dart';
import 'package:motors_app/presentation/screens/add_car/widgets/other_type_widget.dart';
import 'package:motors_app/presentation/screens/add_car/widgets/seller_note_widget.dart';
import 'package:motors_app/presentation/screens/car_detail/car_detail_screen.dart';
import 'package:motors_app/presentation/screens/home_root.dart';
import 'package:motors_app/presentation/widgets/app_bar_icon.dart';
import 'package:motors_app/presentation/widgets/app_elevated_button.dart';
import 'package:motors_app/presentation/widgets/error_custom_widget.dart';
import 'package:motors_app/presentation/widgets/loader_widget.dart';
import 'package:provider/provider.dart';

class StepThreeScreen extends StatefulWidget {
  const StepThreeScreen({
    Key? key,
    this.editDataArg,
  }) : super(key: key);

  static const String routeName = 'add/car/third';

  final EditDataArg? editDataArg;

  @override
  State<StepThreeScreen> createState() => _StepThreeScreenState();
}

class _StepThreeScreenState extends State<StepThreeScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _priceIsEmpty = false;

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
              if (key == 'step_three') {
                value.forEach((key, value) {
                  if (value != null && value != '') {
                    Provider.of<AddCarProvider>(context, listen: false).addCarMap[key] = value;
                    if (key != 'add_media' && key != 'price' && key != 'location' && key != 'features' && key != 'seller_notes' && key != 'mileage' && key != 'fuel-consumption' && key != 'engine') {
                      Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                        type: 'stm_t_s_$key',
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
                        type: 'stm_t_s_engine',
                        element: value,
                      );
                    }

                    if (key == 'mileage') {
                      Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                        type: 'stm_t_s_mileage',
                        element: value,
                      );
                    }

                    if (key == 'fuel-consumptions') {
                      Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                        type: 'stm_t_s_fuel_consumptions',
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
    return BlocListener<AddCarBloc, AddCarState>(
      listener: (context, state) {
        if (state is SuccessEditCarState) {
          if (Provider.of<AddCarProvider>(context, listen: false).addCarImageMap == null || Provider.of<AddCarProvider>(context, listen: false).addCarImageMap!.isEmpty) {
            // Delete added params of car
            Provider.of<AddCarProvider>(context, listen: false).addCarMap.clear();
            // Delete added images
            Provider.of<ImagePickerService>(context, listen: false).clearImages();

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => CarDetailScreen(
                  idCar: int.parse(state.addedCarResponse.postId.toString()),
                  fromAddCar: true,
                ),
              ),
              (Route<dynamic> route) => false,
            );
          } else {
            Map<String, dynamic> mediaData = {};
            List<dynamic> bytesImgList = [];
            dynamic bytesImg;

            mediaData = {
              'user_id': preferences.getString(PreferencesName.userId),
              'user_token': preferences.getString(PreferencesName.apiToken),
              'count': Provider.of<AddCarProvider>(context, listen: false).addCarImageMap?['add_media'].length,
              'post_id': state.addedCarResponse.postId,
            };

            for (var element in Provider.of<AddCarProvider>(context, listen: false).addCarImageMap?['add_media']) {
              if (Provider.of<AddCarProvider>(context, listen: false).addCarImageMap?['add_media'].length > 1) {
                bytesImgList.add(base64Encode(element.readAsBytesSync()));
              } else {
                bytesImg = base64Encode(element.readAsBytesSync());
              }
              if (bytesImgList.isNotEmpty) {
                for (var i = 0; i < bytesImgList.length; i++) {
                  mediaData['photos[]'] = bytesImgList;
                }
              } else {
                mediaData['photos[]'] = bytesImg!;
              }
            }

            BlocProvider.of<AddCarBloc>(context).add(UploadPhotoEvent(data: mediaData));
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text(
                'build_your_ad'.tr(),
                style: kAppBarStyle,
              ),
              Text(
                'step_3'.tr(),
                style: kAppBarSubtitleStyle,
              ),
            ],
          ),
          leading: AppBarIcon(
            iconData: IconsMotors.arrow_back,
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocBuilder<AddCarBloc, AddCarState>(
          builder: (context, state) {
            if (state is InitialAddCarState) {
              return const LoaderWidget();
            }

            if (state is LoadedAddCarParamsState) {
              Map item = state.addCarResponse?.stepThree;

              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: SafeArea(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
                      child: Column(
                        children: item.entries
                            .map(
                              (element) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (element.key == 'add_media')
                                    AddMediaBlock()
                                  else if (element.key == 'engine')
                                    AddFormBlock(
                                      title: 'engine'.tr(),
                                      typeForApi: 'stm_t_s_engine',
                                      hintText: 'engine'.tr(),
                                    )
                                  else if (element.key == 'location')
                                    LocationBlock(typeForApi: 'stm_t_s_location')
                                  else if (element.key == 'price')
                                    AddFormBlock(
                                      title: '${'price'.tr().toUpperCase()}*',
                                      hintText: '$currency $currencyName',
                                      typeForApi: 'stm_car_price',
                                      priceIsEmpty: _priceIsEmpty,
                                      keyboardType: TextInputType.number,
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
                                      typeForApi: 'stm_t_s_mileage',
                                      keyboardType: TextInputType.number,
                                    )
                                  else if (element.key == 'fuel-consumption')
                                    AddFormBlock(
                                      title: 'fuel-consumption'.tr(),
                                      typeForApi: 'stm_t_s_fuel_consumptions',
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
                                      typeForApi: 'stm_t_s_',
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
        bottomNavigationBar: BlocBuilder<AddCarBloc, AddCarState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: AppElevatedButton.secondary(
                onPressed: state is LoadingAddCarState || state is LoadingEditCarState
                    ? null
                    : () {
                        if (state is LoadedAddCarParamsState) {
                          Map item = state.addCarResponse?.stepThree;

                          item.forEach((key, value) {
                            if (key == 'price') {
                              if (!Provider.of<AddCarProvider>(context, listen: false).addCarMap.containsKey('stm_car_price')) {
                                setState(() {
                                  _priceIsEmpty = true;
                                });
                              } else {
                                setState(() {
                                  _priceIsEmpty = false;
                                });
                              }
                            }
                          });
                        }

                        if (!_priceIsEmpty) {
                          String fullNameOfCar = '';
                          String? makeNameF = Provider.of<AddCarProvider>(context, listen: false).addCarMap['stm_f_s_make'];
                          String? makeNameS = Provider.of<AddCarProvider>(context, listen: false).addCarMap['stm_s_s_make'];
                          String? makeNameT = Provider.of<AddCarProvider>(context, listen: false).addCarMap['stm_t_s_make'];
                          String? serieNameF = Provider.of<AddCarProvider>(context, listen: false).addCarMap['stm_f_s_serie'];
                          String? serieNameS = Provider.of<AddCarProvider>(context, listen: false).addCarMap['stm_s_s_serie'];
                          String? serieNameT = Provider.of<AddCarProvider>(context, listen: false).addCarMap['stm_t_s_serie'];

                          if ((makeNameF != null || makeNameS != null || makeNameT != null) && (serieNameF != null || serieNameS != null || serieNameT != null)) {
                            fullNameOfCar = '${makeNameF ?? makeNameS ?? makeNameT} ${serieNameF ?? serieNameS ?? serieNameT}';
                          }

                          Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                            type: 'stm_car_main_title',
                            element: fullNameOfCar,
                          );
                          Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                            type: 'user_id',
                            element: preferences.getString(PreferencesName.userId),
                          );
                          Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                            type: 'user_token',
                            element: preferences.getString(PreferencesName.apiToken),
                          );

                          if (widget.editDataArg?.isEdit ?? false) {
                            Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                              type: 'stm_current_car_id',
                              element: widget.editDataArg?.postId,
                            );
                            Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                              type: 'stm_edit',
                              element: 'update',
                            );

                            BlocProvider.of<AddCarBloc>(context).add(
                              UpdateCarEvent(
                                data: Provider.of<AddCarProvider>(context, listen: false).addCarMap,
                              ),
                            );
                          } else {
                            BlocProvider.of<AddCarBloc>(context).add(
                              AddCar(
                                data: Provider.of<AddCarProvider>(context, listen: false).addCarMap,
                              ),
                            );
                          }
                        }
                      },
                child: state is LoadingAddCarState || state is LoadingEditCarState ? const LoaderWidget() : Text('publish'.tr()),
              ),
            );
          },
        ),
      ),
    );
  }
}
