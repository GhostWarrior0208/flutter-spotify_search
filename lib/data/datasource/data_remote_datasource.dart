import 'dart:convert';
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
      albums.add(Album(
        imageUrl: item['images'][0]['url'],
        albumName: item['name'],
        albumType: item['album_type'],
        artistNames: (item['artists'] as List)
            .map((artist) => artist['name'] as String)
            .toList(),
        releaseDate: item['release_date'],
      ));
    }
    return albums;
  }

  List<Artist> _getArtistsFromResponse({required String response}) {
    List<Artist> artists = [];
    final decodedRes = jsonDecode(response);
    List<dynamic> items = decodedRes['artists']['items'] as List;
    for (var item in items) {
      artists.add(Artist(
        imageUrl: (item['images'] as List).isNotEmpty ? item['images'][0]['url'] : '',
        artistName: item['name'],
      ));
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
          throw ServerException(message: 'Sorry, no data..');
        case 401:
          throw ServerException(message: 'Unathorized');
        case 500:
          throw ServerException(message: 'Internal Server Error');
        default:
          throw ServerException(message: 'Error');
      }
    } on TypeError catch (e) {
      throw CastException(message: e.toString());
    } on UnsupportedError catch (_) {
      throw ServerException(message: 'Server Error');
    } catch (e) {
      rethrow;
    }
  }
}
