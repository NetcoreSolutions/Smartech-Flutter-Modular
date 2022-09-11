import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:smartech_app/app_inbox/utils/utils.dart';
import 'package:smartech_app/deep_link_screen.dart';
import 'package:smartech_app/navigator.dart';
import 'package:smartech_appinbox/model/smt_appinbox_model.dart';
import 'package:url_launcher/url_launcher.dart';

class SMTSimpleNotificationView extends StatelessWidget {
  final SMTAppInboxMessage inbox;
  const SMTSimpleNotificationView({Key? key, required this.inbox}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        children: [
          Padding(
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
                htmlText(inbox.title),
                if (inbox.subtitle.toString() != "") htmlText(inbox.subtitle),
                htmlText(inbox.body),
              ],
            ),
          ),
          inbox.actionButton.length > 0
              ? Container(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  color: Color.fromRGBO(247, 247, 247, 1),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: inbox.actionButton.map((e) {
                      return Expanded(
                          child: Center(
                              child: e.aTyp == 1
                                  ? InkWell(
                                      onTap: () async {
                                        if (e.actionDeeplink.contains("http")) {
                                          print("navigate to browser with url");
                                          final Uri _url = Uri.parse(e.actionDeeplink);
                                          if (!await launchUrl(_url)) throw 'Could not launch $_url';
                                          // await FlutterWebBrowser.openWebPage(url: e.actionDeeplink);
                                        } else {
                                          Map<String, dynamic> dict = HashMap();
                                          dict["actionDeeplink"] = e.actionDeeplink;
                                          dict['isFromScreen'] = true;
                                          NavigationUtilities.pushRoute(
                                            DeepLinkScreen.route,
                                            args: dict,
                                          );
                                        }
                                      },
                                      child: Text(
                                        e.actionName.toString(),
                                        style: TextStyle(color: Color.fromRGBO(75, 79, 81, 1), fontSize: 14, fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  : e.aTyp == 2
                                      ? InkWell(
                                          onTap: () {
                                            Clipboard.setData(ClipboardData(text: e.configCtxt)).then((result) {
                                              final snackBar = SnackBar(
                                                content: Text('Copied'),
                                                duration: Duration(milliseconds: 500),
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar); // -> show a notification
                                            });
                                          },
                                          child: Text(
                                            e.actionName.toString(),
                                            style: TextStyle(color: Color.fromRGBO(75, 79, 81, 1), fontSize: 14, fontWeight: FontWeight.w500),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 0,
                                        )));
                    }).toList(),
                  ),
                )
              : SizedBox(
                  height: 0,
                ),
        ],
      ),
    );
  }
}
