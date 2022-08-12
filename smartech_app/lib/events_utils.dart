import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

List<CategoryModel> eventsAll = List.empty(growable: true);
List<CategoryModel> eventsCategory = List.empty(growable: true);

Future<String> readJson(String name) async {
  return await rootBundle.loadString(name);
}

Future<void> loadEventsJson() async {
  String str = await readJson("assets/json/events.json");
  final data = await json.decode(str);
  debugPrint('Json data ==> $data');

  eventsAll = List.from(data["events"]).map((e) => CategoryModel.fromJson(e)).toList();
  debugPrint('Total Events ==> ${eventsAll.length}');

  eventsAll = eventsAll.where((e) => e.section == "Events").toList();
  debugPrint('Total Filtered Events ==> ${eventsAll.length}');

  eventsAll.sort((a, b) => a.categoryOrder.compareTo(b.categoryOrder));
  debugPrint('Total Events ==> ${eventsAll.length}');

  eventsCategory.clear();
  eventsAll.forEach((e) {
    if (eventsCategory.isCategoryContains(e.category)) eventsCategory.add(e);
  });
  debugPrint('Total Category ==> ${eventsCategory.length}');
}

List<CategoryModel> getEventsList(String category) {
  List<CategoryModel> events = eventsAll.where((e) => e.category == category).toList();
  events.sort((a, b) => a.eventOrder.compareTo(b.eventOrder));
  return events;
}

class CategoryModel {
  String section = "";
  String category = "";
  int categoryOrder = 0;
  int eventOrder = 0;
  String name = "";
  String type = "";
  dynamic payload;

  CategoryModel();

  static CategoryModel fromJson(Map<String, dynamic> json) {
    var model = CategoryModel();
    model.section = json["section"];
    model.category = json["category"];
    model.categoryOrder = json["categoryOrder"];
    model.eventOrder = json["eventOrder"];
    model.name = json["name"];
    model.type = json["type"];
    model.payload = json["payload"];

    return model;
  }
}

extension on List<CategoryModel> {
  bool isCategoryContains(String category) {
    return where((element) => element.category == category).toList().isEmpty;
  }
}
