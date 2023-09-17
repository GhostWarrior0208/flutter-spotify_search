import 'dart:convert';
import 'package:flutter_spotify_search/shared/constants/app_strings.dart';
import 'package:http/http.dart' as http;
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
  final baseUrl = 'https://api.spotify.com/v1/search';

  DataRemoteDataSourceImpl();

  List<Album> _getAlbumsFromResponse({required String response}) {
    List<Album> albums = [];
    final decodedRes = jsonDecode(response);
    List<dynamic> items = decodedRes['albums']['items'] as List;
    for (var item in items) {
      albums.add(Album.fromJson(item as Map<String, dynamic>));
    }
    return albums;
  }

  List<Artist> _getArtistsFromResponse({required String response}) {
    List<Artist> artists = [];
    final decodedRes = jsonDecode(response);
    List<dynamic> items = decodedRes['artists']['items'] as List;
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
      final response = await http.get(
        Uri.parse(
            '$baseUrl?q=$query&type=${type.name.toString()}&market=$market&limit=$limit&offset=$offset&include_external=$includeExternal'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );
      switch (response.statusCode) {
        case 200:
          if (type == DataCategory.album) {
            return _getAlbumsFromResponse(response: response.body);
          } else {
            return _getArtistsFromResponse(response: response.body);
          }
        case 400:
          throw ServerException(message: AppStrings.noData);
        case 401:
          throw ServerException(message: AppStrings.unathorized);
        case 500:
          throw ServerException(message: AppStrings.interServerErr);
        default:
          throw ServerException(message: AppStrings.error);
      }
    } on TypeError catch (e) {
      throw CastException(message: e.toString());
    } on UnsupportedError catch (_) {
      throw ServerException(message: AppStrings.serverErr);
    } catch (e) {
      rethrow;
    }
  }
}
