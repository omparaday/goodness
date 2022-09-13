import 'dart:io';
import 'dart:convert'; //to convert json to maps and vice versa
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart'; //add path provider dart plugin on pubspec.yaml file
import 'package:json_annotation/json_annotation.dart';

part 'DailyData.g.dart';

@JsonSerializable()
class DailyData {
  final double x, y;
  final String quoteKey, about, wordKey;
  final String? deedKey;
  final int goodness;

  DailyData(this.x, this.y, this.quoteKey, this.about, this.wordKey,
      this.deedKey, this.goodness);

  factory DailyData.fromJson(Map<String, dynamic> json) =>
      _$DailyDataFromJson(json);

  Map<String, dynamic> toJson() => _$DailyDataToJson(this);
}

Future<DailyData?>? getDataForDay(String day) async {
  Directory dir = await getApplicationDocumentsDirectory();
  String fileName = day.substring(0, 7);
  File jsonFile = File("${dir.path}/$fileName");
  bool fileExists = jsonFile.existsSync();
  if (fileExists) {
    Map<String, dynamic> fileContent =
        Map<String, dynamic>.from(jsonDecode(jsonFile.readAsStringSync()));
    if (fileContent[day] != null) return DailyData.fromJson(fileContent[day]);
  }
  return null;
}

Future<Map<String, dynamic>?>? getDataForWeek(DateTime date) async {
  Directory dir = await getApplicationDocumentsDirectory();
  DateTime movingDate = date;
  Map<String, dynamic> result = {};
  for (int i = 0; i < 7; i++) {
    String dayKey = getDateKeyFormat(movingDate);
    String fileName = dayKey.substring(0, 7);
    File jsonFile = File("${dir.path}/$fileName");
    bool fileExists = jsonFile.existsSync();
    if (fileExists) {
      Map<String, dynamic> fileContent =
          Map<String, dynamic>.from(jsonDecode(jsonFile.readAsStringSync()));
      if (fileContent[dayKey] != null)
        result.putIfAbsent(dayKey, () => fileContent[dayKey]);
    }
    movingDate = movingDate.add(Duration(days: 1));
  }
  return result;
}

Future<Map<String, dynamic>?>? getDataForMonth(String day) async {
  Directory dir = await getApplicationDocumentsDirectory();
  String fileName = day.substring(0, 7);
  File jsonFile = File("${dir.path}/$fileName");
  bool fileExists = jsonFile.existsSync();
  if (fileExists) {
    return Map<String, dynamic>.from(jsonDecode(jsonFile.readAsStringSync()));
  }
  return null;
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
  Directory dir = await getApplicationDocumentsDirectory();
  Map<String, DailyData> result = {};
  while (true) {
    String day = DateFormat('yyyy-MM-dd').format(historyDate);
    //print(day);
    historyDate = getPreviousDay(historyDate);
    if (historyDate.month == 6 && historyDate.year == 2022) {
      break;
    }
    String fileName = day.substring(0, 7);
    File jsonFile = File("${dir.path}/$fileName");
    bool fileExists = jsonFile.existsSync();
    if (fileExists) {
      Map<String, dynamic> fileContent =
          Map<String, dynamic>.from(jsonDecode(jsonFile.readAsStringSync()));
      if (fileContent[day] != null) {
        result.putIfAbsent(day, () => DailyData.fromJson(fileContent[day]));
        if (result.length == 10) {
          return result;
        }
      }
    } else {
      historyDate = getFirstDayOfMonth(historyDate);
      historyDate = getPreviousDay(historyDate);
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
  print("Creating file!");
  File file = File("${dir.path}/$fileName");
  file.createSync();
  file.writeAsStringSync(jsonEncode(content));
}

void addDailyData(String key, DailyData value) {
  print("Writing to file!");
  String fileName = key.substring(0, 7);
  print(fileName);
  Map<String, dynamic> content = {key: value};
  getApplicationDocumentsDirectory().then((Directory directory) {
    Directory dir = directory;
    File jsonFile = File("${dir.path}/$fileName");
    bool fileExists = jsonFile.existsSync();
    if (fileExists) {
      print("File exists ${jsonFile.readAsStringSync()}");
      Map<String, dynamic> jsonFileContent =
          Map<String, dynamic>.from(jsonDecode(jsonFile.readAsStringSync()));
      jsonFileContent.addAll(content);
      jsonFile.writeAsStringSync(jsonEncode(jsonFileContent));
    } else {
      print("File does not exist!");
      createFile(content, dir, fileName);
    }
    print("File contents ${jsonFile.readAsStringSync()}");
  });
}

String getDateKeyFormat(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
