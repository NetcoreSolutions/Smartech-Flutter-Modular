import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartech_app/app_inbox/utils/utils.dart';
import 'package:smartech_appinbox/model/smt_appinbox_model.dart';

class GIFNotificationView extends StatelessWidget {
  final SMTAppInboxMessage inbox;
  const GIFNotificationView({Key? key, required this.inbox}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                inbox.publishedDate!.getTimeAndDayCount(),
                style: TextStyle(fontSize: 12, color: AppColor.greyColorText, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            htmlText(inbox.title),
            if (inbox.subtitle.toString() != "") htmlText(inbox.subtitle),
            htmlText(inbox.body),
            SizedBox(
              height: 8,
            ),
            inbox.mediaUrl != ""
                ? Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 26,
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Center(
                          child: CupertinoActivityIndicator(),
                        ),
                        imageUrl: inbox.mediaUrl.toString(),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
