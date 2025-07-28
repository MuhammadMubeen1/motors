import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/data/models/main_page/main_page_response.dart';
import 'package:motors_app/presentation/screens/car_detail/car_detail_screen.dart';
import 'package:motors_app/presentation/widgets/list_car_widget.dart';

class RecentlyAddedList extends StatelessWidget {
  const RecentlyAddedList({Key? key, required this.mainPage}) : super(key: key);

  final MainPageResponse mainPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0, right: 20, bottom: 15, left: 20),
          child: Text(
            'recently_added'.tr(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const Divider(
          endIndent: 20,
          indent: 20,
          thickness: 0.5,
          color: Colors.grey,
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: mainPage.recent!.length,
          separatorBuilder: (BuildContext context, int index) => const Divider(
            thickness: 0.5,
            color: Colors.grey,
          ),
          itemBuilder: (BuildContext context, int index) {
            final item = mainPage.recent![index];

            return Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ListCarWidget(
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
            );
          },
        ),
      ],
    );
  }
}
