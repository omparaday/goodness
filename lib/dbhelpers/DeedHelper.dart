import 'dart:convert';
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
const DEED_START_NEG_KEY = 'DEED_START_NEG';

Future<Deed> getNewDeed(bool isHappy) async {
  if (isHappy) {
    return getNewPosDeed();
  }
  return getNewNegDeed();
}

Future<Deed> getNewNegDeed() async {
  String data = await rootBundle.loadString("assets/deeds_neg.json");

  Map<String, dynamic> fileContent =
      Map<String, dynamic>.from(jsonDecode(data));
  final prefs = await SharedPreferences.getInstance();
  int? startPos = prefs.getInt(DEED_START_NEG_KEY);
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
  prefs.setInt(DEED_START_NEG_KEY, (startPos! + 1) % fileContent.length);
  return Deed(deedName, fileContent[deedName]);
}

Future<Deed> getNewPosDeed() async {
  String data = await rootBundle.loadString("assets/deeds.json");

  Map<String, dynamic> fileContent =
      Map<String, dynamic>.from(jsonDecode(data));
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

  Map<String, dynamic> fileContent =
      Map<String, dynamic>.from(jsonDecode(data));
  if (fileContent[deedName] != null) {
    return Deed(deedName, fileContent[deedName] ?? '');
  }
  String dataNeg = await rootBundle.loadString("assets/deeds_neg.json");

  Map<String, dynamic> fileContentNeg =
      Map<String, dynamic>.from(jsonDecode(dataNeg));
  return Deed(deedName, fileContentNeg[deedName] ?? '');
}
