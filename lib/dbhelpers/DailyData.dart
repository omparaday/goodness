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

  DailyData(this.x, this.y, this.quoteKey, this.about, this.wordKey, this.deedKey, this.goodness);

  factory DailyData.fromJson(Map<String, dynamic> json) => _$DailyDataFromJson(json);

  Map<String, dynamic> toJson() => _$DailyDataToJson(this);
}

Future<DailyData?>? getDataForDay(String day) async {
  Directory  dir = await getApplicationDocumentsDirectory();
  String fileName = day.substring(0, 7);
    File jsonFile = File("${dir.path}/$fileName");
    bool fileExists = jsonFile.existsSync();
    if (fileExists) {
      Map<String, dynamic> fileContent = Map<String,dynamic>.from(jsonDecode(jsonFile.readAsStringSync()));
      if (fileContent != null && fileContent[day] != null)
      return DailyData.fromJson(fileContent[day]);
    }
    return null;
}

Future<Map<String, DailyData>?>? getRecentData() async {
  DateTime historyDate = DateTime.now();
  Directory  dir = await getApplicationDocumentsDirectory();
  Map<String, DailyData> result = {};
  while(true) {
    String day = DateFormat('yyyy-MM-dd').format(historyDate);
    //print(day);
    historyDate = historyDate.subtract(Duration(days: 1));
    if (historyDate.month == 6 && historyDate.year == 2022) {
      break;
    }
    String fileName = day.substring(0, 7);
    File jsonFile = File("${dir.path}/$fileName");
    bool fileExists = jsonFile.existsSync();
    if (fileExists) {
      Map<String, dynamic> fileContent = Map<String, dynamic>.from(
          jsonDecode(jsonFile.readAsStringSync()));
      if (fileContent[day] != null) {
        result.putIfAbsent(day, () => DailyData.fromJson(fileContent[day]));
        if (result.length == 10) {
          return result;
        }
      }
    } else {
      historyDate = new DateTime(historyDate.year, historyDate.month, 1, historyDate.hour, historyDate.minute, historyDate.second, historyDate.millisecond, historyDate.microsecond);
      historyDate = historyDate.subtract(Duration(days: 1));
    }
  }
  return result;
}

void createFile(Map<String, dynamic> content, Directory dir, String fileName) {
  print("Creating file!");
  File file = File("${dir.path}/$fileName");
  file.createSync();
  file.writeAsStringSync(jsonEncode(content));
}

void addDailyData(String key, DailyData value) {
  print("Writing to file!");
  String fileName=key.substring(0,7);
  print(fileName);
  Map<String, dynamic> content = {key: value};
  getApplicationDocumentsDirectory().then((Directory directory) {
    Directory dir = directory;
    File jsonFile = File("${dir.path}/$fileName");
    bool fileExists = jsonFile.existsSync();
    if (fileExists) {
      print("File exists ${jsonFile.readAsStringSync()}");
      Map<String, dynamic> jsonFileContent = Map<String, dynamic>.from(
          jsonDecode(jsonFile.readAsStringSync()));
      jsonFileContent.addAll(content);
      jsonFile.writeAsStringSync(jsonEncode(jsonFileContent));
    } else {
      print("File does not exist!");
      createFile(content, dir, fileName);
    }
    print("File contents ${jsonFile.readAsStringSync()}");
  });
}
