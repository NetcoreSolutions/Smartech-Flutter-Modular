import 'dart:convert';
import 'dart:developer';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/dropdown/gf_multiselect.dart';
import 'package:getwidget/types/gf_checkbox_type.dart';
import 'package:smartech_app/app_inbox/model/app_inbox_model_class.dart';
import 'package:smartech_app/app_inbox/widgets/audio_notification_view.dart';
import 'package:smartech_app/app_inbox/widgets/corousle_notification_view.dart';
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
  List<Category> categoryList = [];
  List<Inbox> inboxList = [];
  var appBarHeight = AppBar().preferredSize.height;
  CustomPopupMenuController _controller = CustomPopupMenuController();

  @override
  void initState() {
    // TODO: implement initState
    getCategoryList();
    getMessagesList();
    super.initState();
  }

  @override
  void dispose() {
    _controller.hideMenu();
    super.dispose();
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
      log(json[3].toString());
      inboxList = [...json.map((e) => Inbox.fromJson(e['smtPayload'])).toList()];
      log(inboxList[0].toString());
      setState(() {});
    });
  }

  // var _items = categoryList.map((category) => MultiSelectItem<Category>(category, category.name)).toList();
  List<String> selected = [];

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
          CustomPopupMenu(
            child: Container(
              child: Icon(Icons.add_circle_outline, color: Colors.white),
              padding: EdgeInsets.all(20),
            ),
            menuBuilder: () => Container(
              color: Colors.white,
              width: 150,
              child: Expanded(
                child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(
                          categoryList[index].name,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        autofocus: false,
                        dense: true,
                        activeColor: Colors.green,
                        checkColor: Colors.white,
                        selected: false,
                        value: false,
                        onChanged: (bool? value) {
                          setState(() {
                            // _value = value;
                          });
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 1,
                      );
                    },
                    itemCount: categoryList.length),
              ),
            ),
            pressType: PressType.singleClick,
            verticalMargin: -10,
            controller: _controller,
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        padding: EdgeInsets.only(left: 8, right: 8),
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
                return AudioNotificationView(
                  inbox: inboxList[index],
                );

              case NotificationType.carouselLandscape:
                return CorousleNotificationView(
                  inbox: inboxList[index],
                );

              case NotificationType.simple:
              default:
                return SimpleNotificationView(
                  inbox: inboxList[index],
                );
            }
          },
        ),
      ),
    );
  }
}
