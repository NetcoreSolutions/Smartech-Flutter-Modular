import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartech_app/app_inbox/app_inbox_screen.dart';
import 'package:smartech_app/app_inbox/utils/utils.dart';
import 'package:smartech_appinbox/model/smt_appinbox_model.dart';

class AppInboxClassScreen extends StatefulWidget {
  final SMTAppInboxMessage? args;
  AppInboxClassScreen({Key? key, this.args}) : super(key: key);

  @override
  State<AppInboxClassScreen> createState() => _AppInboxClassScreenState();
}

class _AppInboxClassScreenState extends State<AppInboxClassScreen> {
  SMTAppInboxMessage? smtAppInboxMessage = SMTAppInboxMessage();
  @override
  void initState() {
    smtAppInboxMessage = widget.args;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SMTAppInbox Class"),
        centerTitle: true,
        backgroundColor: AppColor.secondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            MaterialButton(
              child: Text(
                "AppInbox Screen",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              color: Colors.blue,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (builder) => const SMTAppInboxScreen()));
              },
            ),
            Container(
              width: double.infinity,
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      getInfoRow("Title", smtAppInboxMessage?.title),
                      SizedBox(height: 4),
                      getInfoRow("Subtitle", smtAppInboxMessage?.subtitle == "" ? "-" : smtAppInboxMessage?.subtitle ?? '-'),
                      SizedBox(height: 4),
                      getInfoRow("Body", smtAppInboxMessage?.body ?? "-"),
                      SizedBox(height: 4),
                      getInfoRow("TrId", smtAppInboxMessage?.trid ?? ""),
                      SizedBox(height: 4),
                      getInfoRow("Type", smtAppInboxMessage?.type == SMTNotificationType.simple ? "simple" : "-"),
                      SizedBox(height: 4),
                      if (smtAppInboxMessage?.type == SMTNotificationType.image)
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width - 26,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: CupertinoActivityIndicator(),
                              ),
                              imageUrl: smtAppInboxMessage?.mediaUrl ??
                                  'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getInfoRow(String title, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w700),
        ),
        Text(
          value ?? "",
          style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
