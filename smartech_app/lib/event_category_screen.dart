import 'package:flutter/material.dart';
import 'package:smartech_app/app_inbox/utils/utils.dart';
import 'package:smartech_app/event_list_screen.dart';
import 'package:smartech_app/events_utils.dart' as eventUtils;

class EventCategoryScreen extends StatefulWidget {
  const EventCategoryScreen({Key? key}) : super(key: key);

  @override
  _EventCategoryScreenState createState() => _EventCategoryScreenState();
}

class _EventCategoryScreenState extends State<EventCategoryScreen> {
  List<eventUtils.CategoryModel> list = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    list.addAll(eventUtils.eventsCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payload Events"),
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventListScreen(model.category),
                            ));
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    model.category,
                                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Image.asset(
                                  "assets/icons/right-chevron.png",
                                  width: 18,
                                  height: 18,
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
