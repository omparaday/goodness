// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DailyData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyData _$DailyDataFromJson(Map<String, dynamic> json) => DailyData(
      (json['x'] as num).toDouble(),
      (json['y'] as num).toDouble(),
      json['quote'] as String,
      json['about'] as String,
      json['word'] as String,
      json['deed'] as String,
      json['question'] as String,
      json['answer'] as String,
    );

Map<String, dynamic> _$DailyDataToJson(DailyData instance) => <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'quote': instance.quote,
      'about': instance.about,
      'word': instance.word,
      'deed': instance.deed,
      'question': instance.question,
      'answer': instance.answer,
    };
