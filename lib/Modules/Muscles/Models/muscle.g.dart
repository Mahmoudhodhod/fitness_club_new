// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'muscle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusclesResponse _$MusclesResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'MusclesResponse',
      json,
      ($checkedConvert) {
        final val = MusclesResponse(
          muscles: $checkedConvert(
              'muscle_exercises',
              (v) => (v as List<dynamic>)
                  .map((e) => Muscle.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {'muscles': 'muscle_exercises'},
    );

Map<String, dynamic> _$MusclesResponseToJson(MusclesResponse instance) =>
    <String, dynamic>{
      'muscle_exercises': instance.muscles.map((e) => e.toJson()).toList(),
    };

Muscle _$MuscleFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Muscle',
      json,
      ($checkedConvert) {
        final val = Muscle(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          name: $checkedConvert('name', (v) => v as String),
          assets: $checkedConvert(
              'assets', (v) => ImageAsset.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$MuscleToJson(Muscle instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'assets': instance.assets.toJson(),
    };
