import 'dart:io';
import 'dart:convert'; //to convert json to maps and vice versa
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart'; //add path provider dart plugin on pubspec.yaml file
import 'package:json_annotation/json_annotation.dart';

String fileName = "submissions.json";

@JsonSerializable()
class WordData {
  final String word, meaning;

  WordData(this.word, this.meaning);
}

Future<WordData> getNewWord() async {
  String data = await rootBundle.loadString("assets/celebwords_en.json");

  Map<String, dynamic> fileContent = Map<String,dynamic>.from(jsonDecode(data));
  String word = fileContent.keys.elementAt(new Random().nextInt(fileContent.length));
  return WordData(word, fileContent[word]);
}

Future<WordData> getWordForKey(String word) async {
  String data = await rootBundle.loadString("assets/celebwords_en.json");

  Map<String, dynamic> fileContent = Map<String,dynamic>.from(jsonDecode(data));
  return WordData(word, fileContent[word]);
}