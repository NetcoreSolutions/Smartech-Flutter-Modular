import 'package:flutter/material.dart';
import 'package:smartech_app/app_inbox/utils/utils.dart';
import 'package:smartech_app/payload_screen.dart';
import 'package:smartech_app/events_utils.dart' as eventUtils;
import 'package:smartech_base/smartech_base.dart';

class EventListScreen extends StatefulWidget {
  final String category;

  EventListScreen(this.category, {Key? key}) : super(key: key);

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  List<eventUtils.CategoryModel> list = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    list.addAll(eventUtils.getEventsList(widget.category));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        centerTitle: true,
        backgroundColor: AppColor.secondary,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey.shade100,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              ListView.builder(
                itemCount: list.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  eventUtils.CategoryModel model = list.elementAt(index);

                  return Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: InkWell(
                      onTap: () async {
                        debugPrint("Payload data ==> ${model.payload}");
                        await Smartech().trackEvent(model.name, model.payload);
                        showToast("Payload submitted");
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  model.name,
                                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Container(
                                  child: MaterialButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => PayloadScreen(model)));
                                    },
                                    color: Colors.blue,
                                    child: Text(
                                      "View Payload",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            indent: 12,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
