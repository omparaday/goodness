import 'dart:io';
import 'dart:convert'; //to convert json to maps and vice versa
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart'; //add path provider dart plugin on pubspec.yaml file
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

part 'DailyData.g.dart';

@JsonSerializable()
class DailyData {
  final double x, y;
  final String quoteKey, about;
  final String? deedKey, questionKey, answer;
  final int goodness;

  DailyData(this.x, this.y, this.quoteKey, this.about, this.questionKey,
      this.answer, this.deedKey, this.goodness);

  factory DailyData.fromJson(Map<String, dynamic> json) =>
      _$DailyDataFromJson(json);

  Map<String, dynamic> toJson() => _$DailyDataToJson(this);
}

List<Function> writeCallbacks = [];

Future<DailyData?>? getDataForDay(String day) async {
  String monthKey = day.substring(0, 7);
  Map<String, dynamic>? fileContent = await getMonthlyContent(monthKey);
  if (fileContent?[day] != null) return DailyData.fromJson(fileContent?[day]);
  return null;
}

Future<Map<String, dynamic>?>? getDataForWeek(DateTime date) async {
  DateTime movingDate = date;
  Map<String, dynamic> result = {};
  for (int i = 0; i < 7; i++) {
    String dayKey = getDateKeyFormat(movingDate);
    String monthKey = dayKey.substring(0, 7);
    Map<String, dynamic>? fileContent = await getMonthlyContent(monthKey);
    if (fileContent?[dayKey] != null)
      result.putIfAbsent(dayKey, () => fileContent?[dayKey]);
    movingDate = movingDate.add(Duration(days: 1));
  }
  return result;
}

Future<Map<String, dynamic>?>? getDataForMonth(String day) async {
  String monthKey = day.substring(0, 7);
  return getMonthlyContent(monthKey);
}

Future<Map<String, dynamic>?>? getDataForYear(DateTime date) async {
  double totalDays = 0, totalScore = 0;
  DateTime transDate = date;
  Map<String, dynamic> result = {};
  Map<String, double> monthlyData = {};
  Map<String, double> metaData = {};
  while (transDate.year == date.year) {
    Map<String, dynamic>? monthData =
        await getDataForMonth(getDateKeyFormat(transDate));
    int monthDays = 0, monthScore = 0;
    monthData?.forEach((key, value) {
      monthDays++;
      DailyData dd = DailyData.fromJson(value);
      monthScore += dd.goodness;
    });
    totalDays += monthDays;
    totalScore += monthScore;
    if (monthDays != 0) {
      monthlyData.putIfAbsent(
          getMonthName(transDate), () => monthScore / monthDays);
    } else {
      monthlyData.putIfAbsent(getMonthName(transDate), () => 0);
    }
    transDate = getNextMonth(transDate);
  }
  if (totalDays == 0) {
    metaData.putIfAbsent('Average', () => 0);
  } else {
    metaData.putIfAbsent('Average', () => totalScore / totalDays);
  }
  metaData.putIfAbsent('totalScore', () => totalScore);
  metaData.putIfAbsent('totalDays', () => totalDays);
  result.putIfAbsent('monthlyData', () => monthlyData);
  result.putIfAbsent('metaData', () => metaData);
  return result;
}

Future<Map<String, DailyData>?>? getRecentData() async {
  DateTime historyDate = DateTime.now();
  Map<String, DailyData> result = {};
  while (true) {
    String day = DateFormat('yyyy-MM-dd').format(historyDate);
    String monthKey = day.substring(0, 7);
    Map<String, dynamic>? fileContent = await getMonthlyContent(monthKey);
    if (fileContent != null) {
      if (fileContent[day] != null) {
        result.putIfAbsent(day, () => DailyData.fromJson(fileContent[day]));
        if (result.length == 10) {
          return result;
        }
      }
      historyDate = getPreviousDay(historyDate);
    } else {
      historyDate = getFirstDayOfMonth(historyDate);
      historyDate = getPreviousDay(historyDate);
    }
    if (historyDate.month == 6 && historyDate.year == 2022) {
      break;
    }
  }
  return result;
}

DateTime getPreviousDay(DateTime historyDate) =>
    historyDate.subtract(Duration(days: 1));

DateTime getFirstDayOfMonth(DateTime historyDate) => new DateTime(
    historyDate.year,
    historyDate.month,
    1,
    historyDate.hour,
    historyDate.minute,
    historyDate.second,
    historyDate.millisecond,
    historyDate.microsecond);

DateTime getFirstDayOfYear(DateTime historyDate) => new DateTime(
    historyDate.year,
    1,
    1,
    historyDate.hour,
    historyDate.minute,
    historyDate.second,
    historyDate.millisecond,
    historyDate.microsecond);

DateTime getPreviousMonth(DateTime historyDate) => new DateTime(
    historyDate.year,
    historyDate.month - 1,
    1,
    historyDate.hour,
    historyDate.minute,
    historyDate.second,
    historyDate.millisecond,
    historyDate.microsecond);

DateTime getNextMonth(DateTime historyDate) => new DateTime(
    historyDate.year,
    historyDate.month + 1,
    1,
    historyDate.hour,
    historyDate.minute,
    historyDate.second,
    historyDate.millisecond,
    historyDate.microsecond);

DateTime getPreviousYear(DateTime historyDate) => new DateTime(
    historyDate.year - 1,
    1,
    1,
    historyDate.hour,
    historyDate.minute,
    historyDate.second,
    historyDate.millisecond,
    historyDate.microsecond);

DateTime getNextYear(DateTime historyDate) => new DateTime(
    historyDate.year + 1,
    1,
    1,
    historyDate.hour,
    historyDate.minute,
    historyDate.second,
    historyDate.millisecond,
    historyDate.microsecond);

DateTime getFirstDayOfWeek(DateTime date) {
  while ('Sunday' != getDayOfWeek(date)) {
    date = date.subtract(Duration(days: 1));
  }
  return date;
}

String getDayOfWeek(DateTime date) => DateFormat('EEEE').format(date);

String getDisplayDate(DateTime date) =>
    DateFormat('MMM dd, yyyy EEEE').format(date);

String getDisplayDateWithoutDoW(DateTime date) =>
    DateFormat('MMM dd, yyyy').format(date);

String getDisplayDateWithoutYear(DateTime date) =>
    DateFormat('MMM dd, EEEE').format(date);

DateTime getPreviousWeek(DateTime date) {
  return date.subtract(Duration(days: 7));
}

DateTime getNextWeek(DateTime date) {
  return date.add(Duration(days: 7));
}

String getMonthName(DateTime dateTime) {
  return DateFormat('MMMM yyyy').format(dateTime);
}

void createFile(Map<String, dynamic> content, Directory dir, String fileName) {
  File file = File("${dir.path}/$fileName");
  file.createSync();
  file.writeAsStringSync(jsonEncode(content));
}

Future<Map<String, dynamic>?> getMonthlyContent(String monthKey) async {
  if (kIsWeb) {
    final prefs = await SharedPreferences.getInstance();
    var fileContent = prefs.getString(monthKey);
    if (fileContent != null) {
      return Map<String, dynamic>.from(jsonDecode(fileContent));
    }
  } else {
    Directory dir = await getApplicationDocumentsDirectory();
    File jsonFile = File("${dir.path}/$monthKey");
    bool fileExists = jsonFile.existsSync();
    if (fileExists) {
      return Map<String, dynamic>.from(jsonDecode(jsonFile.readAsStringSync()));
    }
  }
  return null;
}

Future<void> addDailyData(String key, DailyData value) async {
  String fileName = key.substring(0, 7);
  Map<String, dynamic> content = {key: value};
  if (kIsWeb) {
    final prefs = await SharedPreferences.getInstance();
    var fileContent = prefs.getString(fileName);
    Map<String, dynamic> jsonFileContent;
    if (fileContent != null) {
      jsonFileContent =
          Map<String, dynamic>.from(jsonDecode(fileContent ?? ''));
      jsonFileContent.addAll(content);
    } else {
      jsonFileContent = new Map();
      jsonFileContent.addAll(content);
    }
    prefs.setString(fileName, jsonEncode(jsonFileContent));
  } else {
    Directory dir = await getApplicationDocumentsDirectory();
    File jsonFile = File("${dir.path}/$fileName");
    bool fileExists = jsonFile.existsSync();
    if (fileExists) {
      Map<String, dynamic> jsonFileContent =
          Map<String, dynamic>.from(jsonDecode(jsonFile.readAsStringSync()));
      jsonFileContent.addAll(content);
      jsonFile.writeAsStringSync(jsonEncode(jsonFileContent));
    } else {
      createFile(content, dir, fileName);
    }
  }
  for (Function f in writeCallbacks) {
    f();
  }
}

void registerWriteCallback(Function f) {
  writeCallbacks.add(f);
}

String getDateKeyFormat(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
