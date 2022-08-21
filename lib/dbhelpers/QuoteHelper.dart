import 'dart:io';
import 'dart:convert'; //to convert json to maps and vice versa
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart'; //add path provider dart plugin on pubspec.yaml file
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Quote {
  final String name, content;

  Quote(this.name, this.content);
}

Future<Quote> getNewQuote() async {
  String data = await rootBundle.loadString("assets/quotes.json");

  Map<String, dynamic> fileContent = Map<String,dynamic>.from(jsonDecode(data));
  String deedName = fileContent.keys.elementAt(new Random().nextInt(fileContent.length));
  return Quote(deedName, fileContent[deedName]);
}