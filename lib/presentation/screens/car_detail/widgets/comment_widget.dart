import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:motors_app/data/models/car_detail/car_detail_response.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({Key? key, required this.carDetailResponse}) : super(key: key);

  final CarDetailResponse carDetailResponse;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  RegExp htmlTags = RegExp('<.+?>');
  bool _isExpandedComments = false;

  @override
  Widget build(BuildContext context) {
    if (widget.carDetailResponse.listingSellerNote != '' && widget.carDetailResponse.listingSellerNote != null && widget.carDetailResponse.listingSellerNote != 'N/A') {
      return buildComment(widget.carDetailResponse.listingSellerNote);
    } else if (widget.carDetailResponse.content != '' && widget.carDetailResponse.content != null && widget.carDetailResponse.content != 'N/A') {
      return buildComment(widget.carDetailResponse.content);
    } else {
      return const SizedBox();
    }
  }

  Widget buildComment(String? comment) {
    return ExpansionPanelList(
      elevation: 0,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isExpandedComments = isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          isExpanded: _isExpandedComments,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, top: 12.5),
              child: Text(
                'dealer_comments'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.only(left: 15.0, bottom: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: htmlTags.hasMatch(comment ?? '')
                  ? Html(data: comment)
                  : Text(
                      comment ?? 'no_comment'.tr(),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
