import 'dart:convert';
import 'dart:developer';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:smartech_app/app_inbox/model/smt_appinbox_model_class.dart';
import 'package:smartech_app/app_inbox/utils/enums.dart';
import 'package:smartech_app/app_inbox/utils/utils.dart';
import 'package:smartech_app/app_inbox/widgets/smt_audio_notification_view.dart';
import 'package:smartech_app/app_inbox/widgets/smt_carousel_notification_view.dart';
import 'package:smartech_app/app_inbox/widgets/smt_gif_notification_view.dart';
import 'package:smartech_app/app_inbox/widgets/smt_image_notification_view.dart';
import 'package:smartech_app/app_inbox/widgets/smt_simple_notification_view.dart';
import 'package:smartech_appinbox/smartech_appinbox.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SMTAppInboxScreen extends StatefulWidget {
  const SMTAppInboxScreen({Key? key}) : super(key: key);

  @override
  State<SMTAppInboxScreen> createState() => _SMTAppInboxScreenState();
}

class _SMTAppInboxScreenState extends State<SMTAppInboxScreen> {
  List<Category> categoryList = [];
  List<SMTInbox> inboxList = [];

  var appBarHeight = AppBar().preferredSize.height;
  CustomPopupMenuController _controller = CustomPopupMenuController();

  @override
  void initState() {
    super.initState();
    getAppInboxCategoryWiseMessageList();
    getMessageListByApiCall();
    getCategoryList();
    // getMessagesList(); // This method use to get all types of notifications
  }

  @override
  void dispose() {
    _controller.hideMenu();
    super.dispose();
  }

  pullToRefreshApiCall() async {
    await getMessageListByApiCall();
    getAppInboxCategoryWiseMessageList();
    getCategoryList();
  }

  getCategoryList() async {
    categoryList = [];
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
      // markMessageAsDismissed("140578-389-101-0-220623122533");
    });
  }

  markMessageAsDismissed(String trid) async {
    await SmartechAppinbox().markMessageAsDismissed(trid);
  }

  markMessageAsClicked(String deeplink, String trid) async {
    await SmartechAppinbox().markMessageAsClicked(deeplink, trid);
  }

  markMessageAsViewed(String trid) async {
    await SmartechAppinbox().markMessageAsViewed(trid);
  }

  /// ======>  This is method to get all notifications <======= ///
  getMessagesList() async {
    await SmartechAppinbox().getAppInboxMessages().then((value) {
      var json = jsonDecode(value.toString());
      log(json.toString());
      // allInboxList = [...json.map((e) => SMTInbox.fromJson(e['smtPayload'])).toList()];
    });
  }

  getMessageListByApiCall() async {
    // inboxList = [];
    await SmartechAppinbox().getAppInboxMessagesByApiCall().then((value) {
      setState(() {});
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
        actions: inboxList.length > 0
            ? [
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
              ]
            : [],
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
            child: inboxList.length > 0
                ? RefreshIndicator(
                    onRefresh: () async {
                      await pullToRefreshApiCall();
                    },
                    child: ListView.builder(
                      itemCount: inboxList.length,
                      itemBuilder: (BuildContext context, int index) {
                        switch (inboxList[index].type) {

                          // ******* Imgae type Notifications ******* \\
                          case SMTNotificationType.image:
                            return VisibilityDetector(
                              key: Key(index.toString()),
                              onVisibilityChanged: (VisibilityInfo info) {
                                var visiblePercentage = info.visibleFraction * 100;
                                log('Widget ${inboxList[index].trid} is ${visiblePercentage}% visible');
                                if (visiblePercentage == 100 && inboxList[index].status.toLowerCase() != "viewed") {
                                  markMessageAsViewed(inboxList[index].trid);
                                  return;
                                }
                              },
                              child: Dismissible(
                                key: Key(inboxList[index].trid),
                                onDismissed: (direction) async {
                                  await markMessageAsDismissed(inboxList[index].trid);
                                  await inboxList.removeAt(index);
                                  await getCategoryList();
                                  setState(() {});
                                },
                                background: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 26),
                                      child: Icon(
                                        Icons.delete_outline,
                                        color: AppColor.greyColorText,
                                      ),
                                    )),
                                child: InkWell(
                                  onTap: () {
                                    markMessageAsClicked(inboxList[index].deeplink, inboxList[index].trid);
                                  },
                                  child: SMTImageNotificationView(
                                    inbox: inboxList[index],
                                  ),
                                ),
                              ),
                            );

                          // ******* GIF type Notifications ******* \\
                          case SMTNotificationType.gif:
                            return VisibilityDetector(
                              key: Key(index.toString()),
                              onVisibilityChanged: (VisibilityInfo info) {
                                var visiblePercentage = info.visibleFraction * 100;
                                log('Widget ${inboxList[index].trid} is ${visiblePercentage}% visible');
                                if (visiblePercentage == 100 && inboxList[index].status.toLowerCase() != "viewed") {
                                  markMessageAsViewed(inboxList[index].trid);
                                  return;
                                }
                              },
                              child: Dismissible(
                                key: Key(inboxList[index].trid),
                                onDismissed: (direction) async {
                                  await markMessageAsDismissed(inboxList[index].trid);
                                  await inboxList.removeAt(index);
                                  await getCategoryList();
                                  setState(() {});
                                },
                                background: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 26),
                                      child: Icon(
                                        Icons.delete,
                                        color: AppColor.greyColorText,
                                      ),
                                    )),
                                child: InkWell(
                                  onTap: () {
                                    markMessageAsClicked(inboxList[index].deeplink, inboxList[index].trid);
                                  },
                                  child: GIFNotificationView(
                                    inbox: inboxList[index],
                                  ),
                                ),
                              ),
                            );

                          // ******* Audio type Notifications ******* \\
                          case SMTNotificationType.audio:
                            return VisibilityDetector(
                              key: Key(index.toString()),
                              onVisibilityChanged: (VisibilityInfo info) {
                                var visiblePercentage = info.visibleFraction * 100;
                                log('Widget ${inboxList[index].trid} is ${visiblePercentage}% visible');
                                if (visiblePercentage == 100 && inboxList[index].status.toLowerCase() != "viewed") {
                                  markMessageAsViewed(inboxList[index].trid);
                                  return;
                                }
                              },
                              child: Dismissible(
                                key: Key(inboxList[index].trid),
                                onDismissed: (direction) async {
                                  await markMessageAsDismissed(inboxList[index].trid);
                                  await inboxList.removeAt(index);
                                  await getCategoryList();
                                  setState(() {});
                                },
                                background: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 26),
                                      child: Icon(
                                        Icons.delete,
                                        color: AppColor.greyColorText,
                                      ),
                                    )),
                                child: InkWell(
                                  onTap: () {
                                    markMessageAsClicked(inboxList[index].deeplink, inboxList[index].trid);
                                  },
                                  child: SMTAudioNotificationView(
                                    inbox: inboxList[index],
                                  ),
                                ),
                              ),
                            );

                          // ******* Carousel type Notifications ******* \\
                          case SMTNotificationType.carouselLandscape:
                          case SMTNotificationType.carouselPortrait:
                            return VisibilityDetector(
                              key: Key(index.toString()),
                              onVisibilityChanged: (VisibilityInfo info) {
                                var visiblePercentage = info.visibleFraction * 100;
                                log('Widget ${inboxList[index].trid} is ${visiblePercentage}% visible');
                                if (visiblePercentage == 100 && inboxList[index].status.toLowerCase() != "viewed") {
                                  markMessageAsViewed(inboxList[index].trid);
                                  return;
                                }
                              },
                              child: Dismissible(
                                key: Key(inboxList[index].trid),
                                onDismissed: (direction) async {
                                  await markMessageAsDismissed(inboxList[index].trid);
                                  await inboxList.removeAt(index);
                                  await getCategoryList();
                                  setState(() {});
                                },
                                background: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 26),
                                      child: Icon(
                                        Icons.delete,
                                        color: AppColor.greyColorText,
                                      ),
                                    )),
                                child: InkWell(
                                  onTap: () {
                                    markMessageAsClicked(inboxList[index].deeplink, inboxList[index].trid);
                                  },
                                  child: SMTCarouselNotificationView(
                                    inbox: inboxList[index],
                                  ),
                                ),
                              ),
                            );

                          // ******* Simple type Notifications ******* \\
                          case SMTNotificationType.simple:
                          default:
                            return VisibilityDetector(
                              key: Key(index.toString()),
                              onVisibilityChanged: (VisibilityInfo info) {
                                var visiblePercentage = info.visibleFraction * 100;
                                log('Widget ${inboxList[index].trid} is ${visiblePercentage}% visible');
                                if (visiblePercentage == 100 && inboxList[index].status.toLowerCase() != "viewed") {
                                  markMessageAsViewed(inboxList[index].trid);
                                  return;
                                }
                              },
                              child: Dismissible(
                                key: Key(inboxList[index].trid),
                                onDismissed: (direction) async {
                                  await markMessageAsDismissed(inboxList[index].trid);
                                  await inboxList.removeAt(index);
                                  await getCategoryList();
                                  setState(() {});
                                },
                                background: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 26),
                                      child: Icon(
                                        Icons.delete,
                                        color: AppColor.greyColorText,
                                      ),
                                    )),
                                child: InkWell(
                                  onTap: () {
                                    markMessageAsClicked(inboxList[index].deeplink, inboxList[index].trid);
                                  },
                                  child: SMTSimpleNotificationView(
                                    inbox: inboxList[index],
                                  ),
                                ),
                              ),
                            );
                        }
                      },
                    ),
                  )
                : Center(
                    child: Text(
                    "There are no notifications for you.",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  )),
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
