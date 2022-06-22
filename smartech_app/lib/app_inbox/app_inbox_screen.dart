import 'dart:convert';
import 'dart:developer';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:smartech_app/app_inbox/model/smt_appinbox_model_class.dart';
import 'package:smartech_app/app_inbox/utils/enums.dart';
import 'package:smartech_app/app_inbox/widgets/smt_audio_notification_view.dart';
import 'package:smartech_app/app_inbox/widgets/smt_carousel_notification_view.dart';
import 'package:smartech_app/app_inbox/widgets/smt_gif_notification_view.dart';
import 'package:smartech_app/app_inbox/widgets/smt_image_notification_view.dart';
import 'package:smartech_app/app_inbox/widgets/smt_simple_notification_view.dart';
import 'package:smartech_appinbox/smartech_appinbox.dart';

class SMTAppInboxScreen extends StatefulWidget {
  const SMTAppInboxScreen({Key? key}) : super(key: key);

  @override
  State<SMTAppInboxScreen> createState() => _SMTAppInboxScreenState();
}

class _SMTAppInboxScreenState extends State<SMTAppInboxScreen> {
  List<Category> categoryList = [];
  List<SMTInbox> inboxList = [];
  List<SMTInbox> allInboxList = [];

  var appBarHeight = AppBar().preferredSize.height;
  CustomPopupMenuController _controller = CustomPopupMenuController();

  var payload = {
    "mDownloadStatus": 0,
    "mIsDownloadInProgress": false,
    "mIsForInbox": false,
    "mMediaLocalPath": "",
    "smtCustomPayload": {},
    "smtPayload": {
      "actionButton": [],
      "appInboxCategory": "cat5",
      "attrParams": {"__sta": "vhg.uosvpxbspoi%7CHYU", "__stm_id": "364", "__stm_medium": "apn", "__stm_source": "smartech"},
      "body": "TEst notification",
      "carousel": [],
      "deeplink": "",
      "isStreamable": false,
      "mediaUrl": "",
      "publishedDate": "2022-06-22T11:23:53",
      "status": "viewed",
      "subTitle": "",
      "timestamp": 1655897044862,
      "title": "Test",
      "trid": "140578-364-94-0-220622165357",
      "trid_original": "140578-364-94-0-220622165357",
      "ttl": "2022-07-13T13:06:41",
      "type": "Simple"
    }
  };

  @override
  void initState() {
    super.initState();
    getCategoryList();
    getAppInboxCategoryWiseMessageList();
    getMessagesList(); // This method use to get all types of notifications
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

  getAppInboxCategoryWiseMessageList() async {
    inboxList = [];
    await SmartechAppinbox()
        .getAppInboxCategoryWiseMessageList(categoryList.where((element) => element.selected).map((e) => e.name).toList())
        .then((value) {
      var json = jsonDecode(value.toString());
      inboxList = [...json.map((e) => SMTInbox.fromJson(e['smtPayload'])).toList()];
      setState(() {});
      // markMessageAsDismissed(payload);
    });
  }

  markMessageAsDismissed(Map<String, dynamic> payload) async {
    await SmartechAppinbox().markMessageAsDismissed(payload);
  }

  /// ======>  This is method to get all notifications <======= ///
  getMessagesList() async {
    await SmartechAppinbox().getAppInboxMessages().then((value) {
      var json = jsonDecode(value.toString());
      log(json.toString());
      allInboxList = [...json.map((e) => SMTInbox.fromJson(e['smtPayload'])).toList()];
      log(allInboxList[0].toString());
      // setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: Text(
            "Notifications",
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        leadingWidth: MediaQuery.of(context).size.width / 2,
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          CustomPopupMenu(
            child: Container(
              child: Icon(Icons.menu, color: Colors.black),
              padding: EdgeInsets.all(20),
            ),
            menuBuilder: () => CategoryListWidget(
              categoryList,
              (selectedList) {
                categoryList = selectedList;
                print(categoryList);
                getAppInboxCategoryWiseMessageList();
                setState(() {});
              },
            ),
            pressType: PressType.singleClick,
            verticalMargin: -10,
            controller: _controller,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 8),
            child: MultiSelectChip(categoryList.where((element) => (element.selected == true)).toList(), onSelectionChanged: (selectedList) {
              getAppInboxCategoryWiseMessageList();
              setState(() {});
            }),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: inboxList.length,
              itemBuilder: (BuildContext context, int index) {
                switch (inboxList[index].type) {
                  case SMTNotificationType.image:
                    return SMTImageNotificationView(
                      inbox: inboxList[index],
                    );

                  case SMTNotificationType.gif:
                    return GIFNotificationView(
                      inbox: inboxList[index],
                    );

                  case SMTNotificationType.audio:
                    return SMTAudioNotificationView(
                      inbox: inboxList[index],
                    );

                  case SMTNotificationType.carouselLandscape:
                  case SMTNotificationType.carouselPortrait:
                    return SMTCarouselNotificationView(
                      inbox: inboxList[index],
                    );

                  case SMTNotificationType.simple:
                  default:
                    return SMTSimpleNotificationView(
                      inbox: inboxList[index],
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<Category> categoryList;
  final Function(List<Category>) onSelectionChanged;
  MultiSelectChip(this.categoryList, {required this.onSelectionChanged});
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  @override
  void initState() {
    super.initState();
    print("selected chip count: " + widget.categoryList.length.toString());
  }

  _buildChoiceList() {
    List<Widget> choices = [];
    widget.categoryList.forEach((item) {
      choices.add(Container(
        padding: EdgeInsets.only(right: 12),
        child: ChoiceChip(
          selectedColor: Colors.white,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                width: 4,
              ),
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.cancel_outlined,
                  size: 22,
                ),
              )
            ],
          ),
          selected: item.selected,
          onSelected: (selected) {
            setState(() {
              item.selected = selected;
              widget.onSelectionChanged(widget.categoryList);
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}

class CategoryListWidget extends StatefulWidget {
  final List<Category> categoryList;
  final Function(List<Category>) onSelected;

  CategoryListWidget(this.categoryList, this.onSelected);

  @override
  State<CategoryListWidget> createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {
  List<Category> categoryList = [];
  @override
  void initState() {
    super.initState();
    categoryList = [...widget.categoryList];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 150,
      child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  categoryList[index].selected = !categoryList[index].selected;
                });
                widget.onSelected(categoryList);
              },
              child: CheckboxListTile(
                title: Text(
                  categoryList[index].name,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                autofocus: false,
                dense: true,
                activeColor: Colors.green,
                checkColor: Colors.white,
                selected: categoryList[index].selected,
                value: categoryList[index].selected,
                onChanged: (bool? value) {
                  setState(() {
                    categoryList[index].selected = !categoryList[index].selected;
                  });
                  widget.onSelected(categoryList);
                },
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 1,
            );
          },
          itemCount: categoryList.length),
    );
  }
}
