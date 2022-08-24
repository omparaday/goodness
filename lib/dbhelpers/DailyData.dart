import 'dart:io';
import 'dart:convert'; //to convert json to maps and vice versa
import 'package:path_provider/path_provider.dart'; //add path provider dart plugin on pubspec.yaml file
import 'package:json_annotation/json_annotation.dart';

part 'DailyData.g.dart';


String fileName = "submissions.json";

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
    File jsonFile = File("${dir.path}/$fileName");
    bool fileExists = jsonFile.existsSync();
    if (fileExists) {
      Map<String, dynamic> fileContent = Map<String,dynamic>.from(jsonDecode(jsonFile.readAsStringSync()));
      return DailyData.fromJson(fileContent[day]);
    }
    return null;

}

void createFile(Map<String, dynamic> content, Directory dir, String fileName) {
  print("Creating file!");
  File file = File("${dir.path}/$fileName");
  file.createSync();
  file.writeAsStringSync(jsonEncode(content));
}

void addDailyData(String key, DailyData value) {
  print("Writing to file!");
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
