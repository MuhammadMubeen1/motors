import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/data/models/main_page/main_page_response.dart';
import 'package:motors_app/presentation/screens/car_detail/car_detail_screen.dart';
import 'package:motors_app/presentation/widgets/grid_car_widget.dart';

class RecentlyAddedGrid extends StatelessWidget {
  const RecentlyAddedGrid({Key? key, required this.mainPage}) : super(key: key);

  final MainPageResponse mainPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
          child: Text(
            'recently_added'.tr(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xff424141),
            ),
          ),
        ),
        const Divider(
          endIndent: 20,
          indent: 20,
          thickness: 0.5,
          color: Colors.grey,
        ),
        ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: mainPage.recent?.length,
          itemBuilder: (BuildContext context, int index) {
            final item = mainPage.recent?[index];

            return GridCarWidget(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarDetailScreen(
                    idCar: item.ID,
                  ),
                ),
              ),
              item: item!,
            );
          },
        ),
      ],
    );
  }
}
