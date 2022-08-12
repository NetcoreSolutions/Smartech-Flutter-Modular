import 'package:flutter/material.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:smartech_app/app_inbox/utils/utils.dart';
import 'package:smartech_base/smartech_base.dart';

class TrackEventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Track Events"),
        centerTitle: true,
        backgroundColor: AppColor.secondary,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            "Add To Cart",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                          color: Colors.blue,
                          onPressed: () {
                            addToCart(context);
                          }),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: MaterialButton(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            "Remove From Cart",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                          color: Colors.blue,
                          onPressed: () {
                            removeFromCart(context);
                          }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            "Expiry Cart",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                          color: Colors.blue,
                          onPressed: () {
                            expiryCart(context);
                          }),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: MaterialButton(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            "Checkout",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                          color: Colors.blue,
                          onPressed: () {
                            checkout(context);
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addToCart(BuildContext context) async {
    var data = {
      "sno": 1,
      "name": "Smartech App",
      "price": 200.00,
      "count": 10,
      "items": [
        {
          "name": "product 1",
          "qty": 10.00,
          "rate": 10,
        },
        {
          "name": "product 2",
          "qty": 10.00,
          "rate": 10,
        }
      ],
    };
    var next = PayloadScreen("Add To Cart", data, () async {
      await Smartech().trackEvent("Add To Cart", data);
    });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => next,
        ));
  }

  void removeFromCart(BuildContext context) async {
    var data = {
      "sno": 1,
      "name": "Smartech App",
      "price": 200.00,
      "count": 10,
      "items": [
        {
          "name": "product 1",
          "qty": 10.00,
          "rate": 10,
        },
        {
          "name": "product 2",
          "qty": 10.00,
          "rate": 10,
        }
      ]
    };
    var next = PayloadScreen("Remove From Cart", data, () async {
      await Smartech().trackEvent("Remove From Cart", data);
    });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => next,
        ));
  }

  void expiryCart(BuildContext context) async {
    var data = {
      "sno": 1,
      "name": "Smartech App",
      "price": 200.00,
      "count": 10,
      "items": [
        {
          "name": "product 1",
          "qty": 10.00,
          "rate": 10,
        },
        {
          "name": "product 2",
          "qty": 10.00,
          "rate": 10,
        }
      ]
    };
    var next = PayloadScreen("Expiry Cart", data, () async {
      await Smartech().trackEvent("Expiry Cart", data);
    });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => next,
        ));
  }

  void checkout(BuildContext context) async {
    var data = {
      "sno": 1,
      "name": "Smartech App",
      "price": 200.00,
      "count": 10,
      "items": [
        {
          "name": "product 1",
          "qty": 10.00,
          "rate": 10,
        },
        {
          "name": "product 2",
          "qty": 10.00,
          "rate": 10,
        }
      ]
    };
    var next = PayloadScreen("Checkout", data, () async {
      await Smartech().trackEvent("Checkout", data);
    });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => next,
        ));
  }
}

class PayloadScreen extends StatelessWidget {
  final Function submit;
  final Map<String, dynamic> payload;
  final String title;
  PayloadScreen(this.title, this.payload, this.submit);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: AppColor.secondary,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Container(child: SingleChildScrollView(child: JsonViewer(payload)))),
            MaterialButton(
                padding: EdgeInsets.all(15),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Submit",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                color: Colors.blue,
                onPressed: () {
                  submit.call();
                }),
          ],
        ),
      ),
    );
  }
}
