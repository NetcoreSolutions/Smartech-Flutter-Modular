import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:smartech_app/app_inbox/model/app_inbox_model_class.dart';
import 'package:smartech_app/app_inbox/widgets/gif_notification_view.dart';
import 'package:smartech_app/app_inbox/widgets/image_notification_view.dart';
import 'package:smartech_app/app_inbox/widgets/simple_notification_view.dart';
import 'package:smartech_app/utils/utils.dart';
import 'package:smartech_appinbox/smartech_appinbox.dart';
import '../utils/enums.dart';

class AppInboxScreen extends StatefulWidget {
  const AppInboxScreen({Key? key}) : super(key: key);

  @override
  State<AppInboxScreen> createState() => _AppInboxScreenState();
}

class _AppInboxScreenState extends State<AppInboxScreen> {
  // final AppInboxModel appInboxModel = AppInboxModel.fromJson({
  //   "inbox_count": 3,
  //   "inbox": [
  //     {
  //       "actionButton": [],
  //       "app_inbox_category": "testappinbox",
  //       "app_inbox_ttl": "2022-07-11T07:08:59",
  //       "attrParams": {"__sta": "vhg.lbghmljxbspoi%7CHYV", "__stm_id": "264", "__stm_medium": "apn", "__stm_source": "smartech"},
  //       "carousel": [],
  //       "customPayload": {},
  //       "deeplink": "",
  //       "expiry": "1657523292",
  //       "image": "",
  //       "message": "my first test push",
  //       "pnMeta": {},
  //       "publishedDate": "2022-06-13T07:13:12",
  //       "smtCustomPayload": {},
  //       "smtSrc": "Smartech",
  //       "sound": true,
  //       "status": "sent",
  //       "subtitle": "",
  //       "timestamp": "1655104534004",
  //       "title": "testjigar",
  //       "trid": "130365-264-2577-0-220613124315",
  //       "type": "Simple"
  //     },
  //     {
  //       "actionButton": [],
  //       "app_inbox_category": "testappinbox",
  //       "app_inbox_ttl": "2022-07-11T07:08:59",
  //       "attrParams": {"__sta": "vhg.lbghmljxbspoi%7CJYV", "__stm_id": "265", "__stm_medium": "apn", "__stm_source": "smartech"},
  //       "carousel": [],
  //       "customPayload": {},
  //       "deeplink": "",
  //       "expiry": "1657523288",
  //       "image": "https://www.motilaloswal.com//campaign//RegistrationOffers//page242//appnotification//Basket9.jpg",
  //       "message": "my first test push with image",
  //       "pnMeta": {},
  //       "publishedDate": "2022-06-14T07:19:41",
  //       "smtCustomPayload": {},
  //       "smtSrc": "Smartech",
  //       "sound": true,
  //       "status": "sent",
  //       "subtitle": "",
  //       "timestamp": "1655104784426",
  //       "title": "testjigarimage",
  //       "trid": "130365-265-2577-0-220613124944",
  //       "type": "Image"
  //     },
  //     {
  //       "actionButton": [],
  //       "app_inbox_category": "testappinboxgif",
  //       "app_inbox_ttl": "2022-07-11T07:08:59",
  //       "attrParams": {"__sta": "vhg.lbghmljxbspoi%7CYYV", "__stm_id": "266", "__stm_medium": "apn", "__stm_source": "smartech"},
  //       "carousel": [],
  //       "customPayload": {},
  //       "deeplink": "",
  //       "expiry": "1657523290",
  //       "image": "https://media2.giphy.com/media/xT0xezQGU5xCDJuCPe/giphy.gif",
  //       "message": "my first test push with image",
  //       "pnMeta": {},
  //       "publishedDate": "2022-06-15T07:24:31",
  //       "smtCustomPayload": {},
  //       "smtSrc": "Smartech",
  //       "sound": true,
  //       "status": "sent",
  //       "subtitle": "",
  //       "timestamp": "1655105075133",
  //       "title": "testjigarimage",
  //       "trid": "130365-266-2577-0-220613125434",
  //       "type": "Gif"
  //     }
  //   ],
  //   "message": "success",
  //   "code": 200
  // });

  List<Category> categoryList = [];
  List<Inbox> inboxList = [];

  @override
  void initState() {
    // TODO: implement initState
    getCategoryList();
    getMessagesList();
    super.initState();
  }

  getCategoryList() async {
    await SmartechAppinbox().getAppInboxCategoryList().then((value) {
      var json = jsonDecode(value.toString());
      categoryList = [...json.map((e) => Category.fromJson(e)).toList()];
      log(categoryList.toString());
    });
  }

  getMessagesList() async {
    await SmartechAppinbox().getAppInboxMessages().then((value) {
      var json = jsonDecode(value.toString());
      log(json[0].toString());
      inboxList = [...json.map((e) => Inbox.fromJson(e)).toList()];
      log(inboxList[0].toString());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
        ),
        centerTitle: true,
        backgroundColor: AppColor.secondary,
        actions: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.menu),
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        child: Expanded(
          child: ListView.builder(
            itemCount: inboxList.length,
            itemBuilder: (BuildContext context, int index) {
              switch (inboxList[index].type) {
                case NotificationType.image:
                  return ImageNotificationView(
                    inbox: inboxList[index],
                  );

                case NotificationType.gif:
                  return GIFNotificationView(
                    inbox: inboxList[index],
                  );

                case NotificationType.audio:
                  return Container();

                case NotificationType.carousel:
                  return Container();

                case NotificationType.simple:
                default:
                  return SimpleNotificationView(
                    inbox: inboxList[index],
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
