import 'package:dio/dio.dart';
import 'package:flutter_spotify_search/shared/constants/app_strings.dart';
import 'package:flutter_spotify_search/shared/exception.dart';
import 'package:flutter_spotify_search/shared/constants/app_enums.dart';
import 'package:flutter_spotify_search/domain/entities/album/album.dart';
import 'package:flutter_spotify_search/domain/entities/artist/artist.dart';

abstract class DataRemoteDataSource {
  Future<dynamic> searchData({
    required String accessToken,
    required String query,
    required DataCategory type,
    String market = 'ES',
    int limit = 20,
    required int offset,
    String includeExternal = '',
  });
}

class DataRemoteDataSourceImpl implements DataRemoteDataSource {
  final Dio dio;
  final baseUrl = 'https://api.spotify.com/v1/search';

  DataRemoteDataSourceImpl({required this.dio});

  List<Album> _getAlbumsFromResponse({required Map<String, dynamic> response}) {
    List<Album> albums = [];
    List<dynamic> items = response['albums']['items'] as List;
    for (var item in items) {
      albums.add(Album.fromJson(item as Map<String, dynamic>));
    }
    return albums;
  }

  List<Artist> _getArtistsFromResponse({required Map<String, dynamic> response}) {
    List<Artist> artists = [];
    List<dynamic> items = response['artists']['items'] as List;
    for (var item in items) {
      artists.add(Artist.fromJson(item as Map<String, dynamic>));
    }
    return artists;
  }

  @override
  Future searchData({
    required String accessToken,
    required String query,
    required DataCategory type,
    String market = 'ES',
    int limit = 20,
    required int offset,
    String includeExternal = '',
  }) async {
    try {
      final response = await dio.get(
        '$baseUrl?q=$query&type=${type.name.toString()}&market=$market&limit=$limit&offset=$offset&include_external=$includeExternal',
        options: Options(
          headers: <String, String>{
              'Authorization': 'Bearer $accessToken',
            },
        ),
      );
      switch (response.statusCode) {
        case 200:
          if (type == DataCategory.album) {
            return _getAlbumsFromResponse(response: response.data);
          } else {
            return _getArtistsFromResponse(response: response.data);
          }
        case 400:
          throw ServerException(message: AppStrings.badRequest);
        case 401:
          throw ServerException(message: AppStrings.unathorized);
        case 403:
          throw ServerException(message: AppStrings.unathorized);
        case 404:
          throw ServerException(message: AppStrings.noData);
        case 429:
          throw ServerException(message: AppStrings.rateLimitErr);
        case 500:
          throw ServerException(message: AppStrings.serverErr);
        default:
          throw ServerException(message: AppStrings.unknownErr);
      }
    } on TypeError catch (_) {
      throw CastException(message: AppStrings.castErr);
    } on UnsupportedError catch (_) {
      throw ServerException(message: AppStrings.serverErr);
    } catch (e) {
      rethrow;
    }
  }
}
