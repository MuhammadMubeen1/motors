import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/styles/app_color.dart';
import 'package:motors_app/data/models/base_models/base_car_response.dart';
import 'package:motors_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:motors_app/presentation/screens/car_detail/car_detail_screen.dart';
import 'package:motors_app/presentation/widgets/alert_dialog.dart';
import 'package:motors_app/presentation/widgets/app_elevated_button.dart';
import 'package:motors_app/presentation/widgets/list_car_widget.dart';
import 'package:motors_app/presentation/widgets/loader_widget.dart';

class InventoryWidget extends StatefulWidget {
  const InventoryWidget({super.key, required this.listings});

  final List<BaseCarDetailResponse> listings;

  @override
  State<InventoryWidget> createState() => _InventoryWidgetState();
}

class _InventoryWidgetState extends State<InventoryWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.listings.isEmpty) {
      return Center(
        child: Text(
          'send_message'.tr(),
          style: TextStyle(
            color: ColorApp.grey1,
            fontSize: 15,
          ),
        ),
      );
    } else {
      return Column(
        children: widget.listings
            .map(
              (item) => ListCarWidget(
                item: item,
                additionalBottomWidget: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0, top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 35,
                              child: AppElevatedButton.error(
                                onPressed: state is LoadingDeleteCarState
                                    ? null
                                    : () {
                                        showBaseDialog(
                                          context,
                                          title: 'are_you_sure_delete_car'.tr(),
                                          content: 'are_you_sure_delete_car_desc'.tr(),
                                          onPressed: state is LoadingDeleteCarState
                                              ? null
                                              : () {
                                                  BlocProvider.of<ProfileBloc>(context).add(
                                                    DeleteCarEvent(
                                                      carId: item.ID,
                                                    ),
                                                  );
                                                },
                                        );
                                      },
                                child: state is LoadingDeleteCarState ? LoaderWidget() : Text('delete'.tr()),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: SizedBox(
                              height: 35,
                              child: AppElevatedButton.secondary(
                                onPressed: state is LoadingEditCarState
                                    ? null
                                    : () {
                                        BlocProvider.of<ProfileBloc>(context).add(
                                          EditCarEvent(
                                            carId: item.ID,
                                          ),
                                        );
                                      },
                                child: state is LoadingEditCarState ? LoaderWidget() : Text('update'.tr()),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarDetailScreen(idCar: item.ID),
                  ),
                ),
              ),
            )
            .toList(),
      );
    }
  }
}

/* isInventory: true,
                    isActive: state is LoadingEditCarState || state is LoadingDeleteCarState,
                    onEdit: () async => BlocProvider.of<ProfileBloc>(context).add(
                      EditCarEvent(
                        carId: item.ID,
                      ),
                    ),
                    onDelete: () {
                      // TODO: 23.11.2023 Add translations
                      showBaseDialog(
                        context,
                        title: 'Are you sure to delete car?',
                        content: 'Вы не сможете восстановить эту машину, при удаление',
                        onPressed: state is LoadingDeleteCarState
                            ? null
                            : () {
                                BlocProvider.of<ProfileBloc>(context).add(
                                  DeleteCarEvent(
                                    carId: item.ID,
                                  ),
                                );
                              },
                      );
                    },*/
