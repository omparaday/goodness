import 'dart:convert'; //to convert json to maps and vice versa
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../profile.dart';

@JsonSerializable()
class Deed {
  final String name, content;

  Deed(this.name, this.content);
}
const DEED_START_KEY = 'DEED_START';

Future<Deed> getNewDeed() async {
  String data = await rootBundle.loadString("assets/deeds.json");

  Map<String, dynamic> fileContent = Map<String,dynamic>.from(jsonDecode(data));
  final prefs = await SharedPreferences.getInstance();
  int? startPos = prefs.getInt(DEED_START_KEY);
  if (startPos == null) {
    startPos = new Random().nextInt(fileContent.length);
  }
  bool disabled = (prefs.getBool(ProfilePage.KEY_DISABLED) ?? false);
  String deedName = fileContent.keys.elementAt(startPos);
  if (disabled) {
    while (deedName.startsWith('move')) {
      startPos = (startPos! + 1) % fileContent.length;
      deedName = fileContent.keys.elementAt(startPos);
    }
  }
  prefs.setInt(DEED_START_KEY, (startPos! + 1) % fileContent.length);
  return Deed(deedName, fileContent[deedName]);
}

Future<Deed> getDeedForKey(String deedName) async {
  String data = await rootBundle.loadString("assets/deeds.json");

  Map<String, dynamic> fileContent = Map<String,dynamic>.from(jsonDecode(data));
  return Deed(deedName, fileContent[deedName]?? '');
}