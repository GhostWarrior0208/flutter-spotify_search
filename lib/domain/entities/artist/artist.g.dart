// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// ignore: non_constant_identifier_names
_$_Artist _$$_ArtistFromJson(Map<String, dynamic> json) => _$_Artist(
      imageUrl: (json['images'] as List).isNotEmpty ? json['images'][0]['url'] as String : '',
      artistName: json['name'] as String,
    );

// ignore: non_constant_identifier_names
Map<String, dynamic> _$$_ArtistToJson(_$_Artist instance) => <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'artistName': instance.artistName,
    };
