import 'package:flutter/material.dart';
import 'package:smartech_app/app_inbox/model/smt_appinbox_model_class.dart';
import 'package:smartech_app/app_inbox/utils/utils.dart';

class SMTSimpleNotificationView extends StatelessWidget {
  final SMTInbox inbox;
  const SMTSimpleNotificationView({Key? key, required this.inbox}) : super(key: key);
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
            Text(
              inbox.title,
              style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              inbox.body,
              style: TextStyle(fontSize: 14, color: AppColor.greyColorText, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
