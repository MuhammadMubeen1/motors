import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/text_styles.dart';
import 'package:motors_app/presentation/bloc/dealer_profile/dealer_profile_bloc.dart';
import 'package:motors_app/presentation/screens/car_detail/car_detail_screen.dart';
import 'package:motors_app/presentation/widgets/app_bar_icon.dart';
import 'package:motors_app/presentation/widgets/app_elevated_button.dart';
import 'package:motors_app/presentation/widgets/cached_image_widget.dart';
import 'package:motors_app/presentation/widgets/list_car_widget.dart';
import 'package:motors_app/presentation/widgets/loader_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class DealerProfile extends StatelessWidget {
  const DealerProfile({Key? key, this.dealerId}) : super(key: key);

  static const String routeName = 'dealerProfileScreen';

  final dynamic dealerId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DealerProfileBloc()
        ..add(
          LoadDealerProfileEvent(
            dealerId: dealerId,
          ),
        ),
      child: Scaffold(
        appBar: AppBar(
          leading: AppBarIcon(
            iconData: IconsMotors.arrow_back,
            onTap: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: Text(
            'dealer_profile'.tr(),
            style: kAppBarStyle,
          ),
        ),
        body: BlocBuilder<DealerProfileBloc, DealerProfileState>(
          builder: (context, state) {
            if (state is InitialDealerProfileState) {
              return const LoaderWidget();
            }

            if (state is LoadedDealerProfileState) {
              final author = state.dealerResponse.author;

              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      // Avatar
                      Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 35,
                          child: ClipOval(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                              child: CachedNetworkCustomImage(
                                imgUrl: '${author?.image}',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Dealer name
                      Text(
                        author?.name != null && author?.name != '' ? author?.name : 'No info',
                        style: const TextStyle(
                          fontFamily: 'SFProDisplay-Semibold',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      // Call button and sms button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25),
                        child: Row(
                          mainAxisAlignment: author?.phone == null || author?.phone == '' ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
                          children: [
                            // Phone
                            if (author?.phone != null && author?.phone != '')
                              Flexible(
                                child: AppElevatedButton.secondary(
                                  onPressed: () async {
                                    if (author?.phone == null || author?.phone == '') {
                                      log('No phone');
                                    } else {
                                      final Uri launchUri = Uri(scheme: 'tel', path: author?.phone);

                                      if (await canLaunchUrl(launchUri)) {
                                        await launchUrl(launchUri);
                                      } else {
                                        throw 'Could not launch $launchUri';
                                      }
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(IconsMotors.phone, size: 15),
                                      const SizedBox(width: 5),
                                      Text(
                                        author?.phone,
                                        style: const TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            const SizedBox(width: 10.0),
                            if (author?.email != null && author?.email != '')
                              // Message
                              Flexible(
                                child: AppElevatedButton.white(
                                  onPressed: () async {
                                    if (author?.phone != null && author?.phone != '') {
                                      final Uri launchUri = Uri(scheme: 'sms', path: author?.phone);

                                      await launchUrl(launchUri);
                                    } else {
                                      final Uri launchUri = Uri(scheme: 'mailto', path: author?.email);

                                      await launchUrl(launchUri);
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        IconsMotors.message,
                                        size: 15,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'send_message'.tr(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Sellers Inventory
                      Text(
                        'sellers_inventory'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'SFProDisplay-Bold',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Divider(
                        endIndent: 40,
                        indent: 40,
                        thickness: 0.5,
                        color: Colors.black,
                      ),
                      // Listings
                      if (state.dealerResponse.listings != null && state.dealerResponse.listings!.isNotEmpty)
                        Column(
                          children: state.dealerResponse.listings!
                              .map(
                                (item) => ListCarWidget(
                                  item: item,
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
                        )
                      else
                        Text('Listings is empty'),
                    ],
                  ),
                ),
              );
            }

            return Center(
              child: Text(
                'error'.tr(),
              ),
            );
          },
        ),
        bottomNavigationBar: const SizedBox(height: 0),
      ),
    );
  }
}
