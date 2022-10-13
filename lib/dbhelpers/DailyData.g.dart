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
      json['questionKey'] as String?,
      json['answer'] as String?,
      json['deed'] as String?,
      json['goodness'] as int,
    );

Map<String, dynamic> _$DailyDataToJson(DailyData instance) => <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'quote': instance.quoteKey,
      'about': instance.about,
      'questionKey': instance.questionKey,
      'answer': instance.answer,
      'deed': instance.deedKey,
      'goodness': instance.goodness,
    };
