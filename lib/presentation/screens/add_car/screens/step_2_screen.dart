import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/components/image_picker.dart';
import 'package:motors_app/core/constants/preferences_name.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/text_styles.dart';
import 'package:motors_app/presentation/bloc/add_car/add_car_bloc.dart';
import 'package:motors_app/presentation/screens/add_car/components/add_car_provider.dart';
import 'package:motors_app/presentation/screens/add_car/components/image_picker_service.dart';
import 'package:motors_app/presentation/screens/add_car/screens/step_3_screen.dart';
import 'package:motors_app/presentation/screens/add_car/widgets/add_form.dart';
import 'package:motors_app/presentation/screens/add_car/widgets/add_media_widget.dart';
import 'package:motors_app/presentation/screens/add_car/widgets/features_widget.dart';
import 'package:motors_app/presentation/screens/add_car/widgets/location_widget.dart';
import 'package:motors_app/presentation/screens/add_car/widgets/other_type_widget.dart';
import 'package:motors_app/presentation/screens/add_car/widgets/seller_note_widget.dart';
import 'package:motors_app/presentation/screens/car_detail/car_detail_screen.dart';
import 'package:motors_app/presentation/screens/home_root.dart';
import 'package:motors_app/presentation/widgets/alert_dialog.dart';
import 'package:motors_app/presentation/widgets/app_elevated_button.dart';
import 'package:motors_app/presentation/widgets/error_custom_widget.dart';
import 'package:motors_app/presentation/widgets/loader_widget.dart';
import 'package:provider/provider.dart';

class StepTwoScreen extends StatefulWidget {
  const StepTwoScreen({
    Key? key,
    this.editDataArg,
  }) : super(key: key);

  static const String routeName = 'add/car/second';

  final EditDataArg? editDataArg;

  @override
  State<StepTwoScreen> createState() => _StepTwoScreenState();
}

class _StepTwoScreenState extends State<StepTwoScreen> {
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
              if (key == 'step_two') {
                (value as Map).forEach((key, value) {
                  if (value != null && value != '') {
                    if (key != 'add_media' && key != 'price' && key != 'location' && key != 'features' && key != 'fuel-consumption' && key != 'mileage' && key != 'seller_notes' && key != 'engine') {
                      Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                        type: 'stm_s_s_$key',
                        element: value.values.toString().substring(
                              1,
                              value.values.toString().length - 1,
                            ),
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
                        type: 'stm_s_s_engine',
                        element: value,
                      );
                    }

                    if (key == 'mileage') {
                      Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                        type: 'stm_s_s_mileage',
                        element: value,
                      );
                    }

                    if (key == 'fuel_consumptions') {
                      Provider.of<AddCarProvider>(context, listen: false).addCarParams(
                        type: 'stm_s_s_fuel_consumptions',
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
        if (state is SuccessAddedCarState) {
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

        if (state is ErrorAddCarState) {
          showBaseDialog(
            context,
            title: state.message ?? 'Error add car',
            content: state.specificError ?? 'Please check your fields',
          );

          BlocProvider.of<AddCarBloc>(context).add(LoadAddCarParamsEvent());
        }

        if (state is SuccessUploadCarPhotoState) {
          Provider.of<AddCarProvider>(context, listen: false).addCarMap.clear();
          Provider.of<AddCarProvider>(context, listen: false).addCarImageMap?.clear();
          Provider.of<ImagePickerService>(context, listen: false).clearImages();

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => CarDetailScreen(
                idCar: int.parse(state.response['post']),
                fromAddCar: true,
              ),
            ),
            (Route<dynamic> route) => false,
          );
        }

        if (state is ErrorUploadPhotoState) {
          showBaseDialog(
            context,
            title: 'Error',
            content: state.message ?? 'Error upload photo car, please try again',
          );
        }

        if (state is SuccessEditCarState) {
          if (!Provider.of<AddCarProvider>(context, listen: false).addCarMap.containsKey('add_media')) {
            Provider.of<AddCarProvider>(context, listen: false).addCarMap.clear();
            Provider.of<ImagePickerProvider>(context, listen: false).deleteAllImage();

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
              'count': Provider.of<AddCarProvider>(context, listen: false).addCarMap['add_media'].length,
              'post_id': widget.editDataArg?.postId,
              'stm_edit': 'update',
            };

            Provider.of<AddCarProvider>(context, listen: false).addCarMap.forEach((key, value) {
              if (key == 'add_media') {
                for (var element in value) {
                  if (value.length > 1) {
                    bytesImgList.add(base64Encode(element.readAsBytesSync()));
                  } else {
                    bytesImg = base64Encode(element.readAsBytesSync());
                  }
                }

                if (bytesImgList.isNotEmpty) {
                  for (var i = 0; i < bytesImgList.length; i++) {
                    mediaData['photos[]'] = bytesImgList;
                  }
                } else {
                  mediaData['photos[]'] = bytesImg!;
                }
              }
            });

            BlocProvider.of<AddCarBloc>(context).add(UploadPhotoEvent(data: mediaData));
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Column(
            children: [
              Text(
                'build_your_ad'.tr(),
                style: kAppBarStyle,
              ),
              Text(
                'step_2'.tr(),
                style: kAppBarSubtitleStyle,
              ),
            ],
          ),
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 0.5, color: Colors.grey),
              ),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(
                    IconsMotors.arrow_back,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: BlocBuilder<AddCarBloc, AddCarState>(
          builder: (context, state) {
            if (state is InitialAddCarState) {
              return LoaderWidget();
            }

            if (state is LoadedAddCarParamsState) {
              Map<String, dynamic> item = {};
              if (state.addCarResponse?.stepTwo.isEmpty) {
                item = {};
              } else {
                item = state.addCarResponse?.stepTwo;
              }

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
                                      typeForApi: 'stm_s_s_engine',
                                      hintText: 'engine'.tr(),
                                    )
                                  else if (element.key == 'location')
                                    LocationBlock(typeForApi: 'stm_s_s_location')
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
                                      typeForApi: 'stm_s_s_mileage',
                                      keyboardType: TextInputType.number,
                                    )
                                  else if (element.key == 'fuel-consumption')
                                    AddFormBlock(
                                      title: 'fuel-consumption'.tr(),
                                      typeForApi: 'stm_s_s_fuel_consumptions',
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
                                      typeForApi: 'stm_s_s_',
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

            return LoaderWidget();
          },
        ),
        bottomNavigationBar: BlocBuilder<AddCarBloc, AddCarState>(
          builder: (context, state) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: Row(
                children: [
                  Expanded(
                    child: AppElevatedButton.secondary(
                      onPressed: state is LoadingAddCarState || state is LoadingEditCarState
                          ? null
                          : () {
                              if (state is LoadedAddCarParamsState) {
                                Map item = state.addCarResponse?.stepTwo;

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
                      child: state is LoadingAddCarState || state is LoadingEditCarState
                          ? const LoaderWidget()
                          : Text(
                              'publish'.tr(),
                            ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: AppElevatedButton.secondary(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StepThreeScreen(
                              editDataArg: widget.editDataArg,
                            ),
                          ),
                        );
                      },
                      child: Text('additional'.tr()),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
