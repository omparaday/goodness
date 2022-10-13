import 'dart:convert'; //to convert json to maps and vice versa
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

@JsonSerializable()
class Quote {
  final String name, content;

  Quote(this.name, this.content);
}
const QUOTE_START_KEY = 'QUOTE_START';

Future<Quote> getNewQuote() async {
  String data = await rootBundle.loadString("assets/quotes.json");

  Map<String, dynamic> fileContent = Map<String,dynamic>.from(jsonDecode(data));
  final prefs = await SharedPreferences.getInstance();
  int? startPos = prefs.getInt(QUOTE_START_KEY);
  if (startPos == null) {
    startPos = new Random().nextInt(fileContent.length);
  }
  String quoteName = fileContent.keys.elementAt(startPos);
  prefs.setInt(QUOTE_START_KEY, (startPos + 1) % fileContent.length);
  return Quote(quoteName, fileContent[quoteName]);
}

Future<Quote> getQuoteForKey(String quoteName) async {
  String data = await rootBundle.loadString("assets/quotes.json");

  Map<String, dynamic> fileContent = Map<String,dynamic>.from(jsonDecode(data));
  return Quote(quoteName, fileContent[quoteName]);
}