import 'package:freezed_annotation/freezed_annotation.dart';

part 'album.freezed.dart';

@freezed
class Album with _$Album {
  const factory Album({
    required String imageUrl,
    required String albumType,
    required String albumName,
    required List<String> artistNames,
    required String releaseDate,
  }) = _Album;
}