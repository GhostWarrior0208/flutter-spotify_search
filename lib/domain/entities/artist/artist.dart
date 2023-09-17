import 'package:freezed_annotation/freezed_annotation.dart';

part 'artist.freezed.dart';

@freezed
class Artist with _$Artist {
  const factory Artist({
    required String imageUrl,
    required String artistName,
  }) = _Artist;
}