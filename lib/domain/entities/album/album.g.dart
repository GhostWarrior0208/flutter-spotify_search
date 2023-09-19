// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// ignore: non_constant_identifier_names
_$_Album _$$_AlbumFromJson(Map<String, dynamic> json) => _$_Album(
      imageUrl: json['images'][0]['url'] as String,
      albumType: json['album_type'] as String,
      albumName: json['name'] as String,
      artistNames: (json['artists'] as List<dynamic>)
          .map((e) => e['name'] as String)
          .toList(),
      releaseDate: json['release_date'] as String,
    );

// ignore: non_constant_identifier_names
Map<String, dynamic> _$$_AlbumToJson(_$_Album instance) => <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'albumType': instance.albumType,
      'albumName': instance.albumName,
      'artistNames': instance.artistNames,
      'releaseDate': instance.releaseDate,
    };
