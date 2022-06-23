import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smartech_app/app_inbox/model/smt_appinbox_model_class.dart';
import 'package:smartech_app/app_inbox/utils/utils.dart';

class SMTCarouselNotificationView extends StatefulWidget {
  final SMTInbox inbox;
  const SMTCarouselNotificationView({Key? key, required this.inbox}) : super(key: key);

  @override
  State<SMTCarouselNotificationView> createState() => _SMTCarouselNotificationViewState();
}

class _SMTCarouselNotificationViewState extends State<SMTCarouselNotificationView> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  List<Widget> imageSliders = [];

  @override
  void initState() {
    super.initState();
    imageSliders = widget.inbox.carousel
        .map((item) => Column(
              children: <Widget>[
                Container(
                  height: 150,
                  width: double.infinity,
                  child: Image.network(
                    item.imgUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '${item.imgTitle.toString()}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '${item.imgMsg.toString()}',
                  style: TextStyle(
                    color: AppColor.greyColorText,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ))
        .toList();
  }

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
                widget.inbox.publishedDate!.getTimeAndDayCount(),
                style: TextStyle(fontSize: 12, color: AppColor.greyColorText, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              widget.inbox.title,
              style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              widget.inbox.body,
              style: TextStyle(fontSize: 14, color: AppColor.greyColorText, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 16,
            ),
            Column(children: [
              CarouselSlider(
                items: imageSliders,
                carouselController: _controller,
                options: CarouselOptions(
                    autoPlay: false,
                    enlargeCenterPage: true,
                    aspectRatio: 1.8,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.inbox.carousel.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)
                              .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList(),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
