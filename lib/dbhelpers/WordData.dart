import 'dart:convert'; //to convert json to maps and vice versa
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

@JsonSerializable()
class WordData {
  final String word, meaning;

  WordData(this.word, this.meaning);
}
const CELEB_WORD_START_KEY = 'CELEBWORD_START';
const CELEB_WORD_FILEPATH = 'assets/celebwords_en.json';
const MOTIVE_WORD_START_KEY = 'MOTIVWORD_START';
const MOTIVE_WORD_FILEPATH = 'assets/motivewords_en.json';

Future<WordData> getNewWord(bool isHappy) async {
  if (isHappy) {
    String data = await rootBundle.loadString(CELEB_WORD_FILEPATH);

    Map<String, dynamic> fileContent = Map<String, dynamic>.from(
        jsonDecode(data));
    final prefs = await SharedPreferences.getInstance();
    int? startPos = prefs.getInt(CELEB_WORD_START_KEY);
    if (startPos == null) {
      startPos = new Random().nextInt(fileContent.length);
    }
    String word = fileContent.keys.elementAt(startPos);
    prefs.setInt(CELEB_WORD_START_KEY, (startPos + 1) % fileContent.length);
    return WordData(word, fileContent[word]);
  }
  String data = await rootBundle.loadString(MOTIVE_WORD_FILEPATH);

  Map<String, dynamic> fileContent = Map<String, dynamic>.from(
      jsonDecode(data));
  final prefs = await SharedPreferences.getInstance();
  int? startPos = prefs.getInt(MOTIVE_WORD_START_KEY);
  if (startPos == null) {
    startPos = new Random().nextInt(fileContent.length);
  }
  String word = fileContent.keys.elementAt(startPos);
  prefs.setInt(MOTIVE_WORD_START_KEY, (startPos + 1) % fileContent.length);
  return WordData(word, fileContent[word]);
}

Future<WordData> getWordForKey(String word) async {
  String data = await rootBundle.loadString(CELEB_WORD_FILEPATH);

  Map<String, dynamic> fileContent = Map<String,dynamic>.from(jsonDecode(data));
  if (fileContent[word] != null) {
    return WordData(word, fileContent[word]);
  }
  data = await rootBundle.loadString(MOTIVE_WORD_FILEPATH);

  fileContent = Map<String,dynamic>.from(jsonDecode(data));
  return WordData(word, fileContent[word]);
}