import 'dart:io';
import 'dart:convert'; //to convert json to maps and vice versa
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart'; //add path provider dart plugin on pubspec.yaml file
import 'package:json_annotation/json_annotation.dart';

String fileName = "submissions.json";

@JsonSerializable()
class Deed {
  final String name, content;

  Deed(this.name, this.content);
}

Future<Deed> getNewDeed() async {
  String data = await rootBundle.loadString("assets/deeds.json");

  Map<String, dynamic> fileContent = Map<String,dynamic>.from(jsonDecode(data));
  String deedName = fileContent.keys.elementAt(new Random().nextInt(fileContent.length));
  return Deed(deedName, fileContent[deedName]);
}