import 'dart:convert'; //to convert json to maps and vice versa
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

@JsonSerializable()
class Question {
  final String key, content;

  Question(this.key, this.content);
}
const QUESTION_START_KEY = 'QUESTION_START';

Future<Question> getNewQuestion() async {
  String data = await rootBundle.loadString("assets/questions.json");

  Map<String, dynamic> fileContent = Map<String,dynamic>.from(jsonDecode(data));
  final prefs = await SharedPreferences.getInstance();
  int? startPos = prefs.getInt(QUESTION_START_KEY);
  if (startPos == null) {
    startPos = new Random().nextInt(fileContent.length);
  }
  String questionKey = fileContent.keys.elementAt(startPos);
  prefs.setInt(QUESTION_START_KEY, (startPos + 1) % fileContent.length);
  return Question(questionKey, fileContent[questionKey]);
}

Future<Question> getQuestionForKey(String questionKey) async {
  String data = await rootBundle.loadString("assets/questions.json");

  Map<String, dynamic> fileContent = Map<String,dynamic>.from(jsonDecode(data));
  return Question(questionKey, fileContent[questionKey]);
}