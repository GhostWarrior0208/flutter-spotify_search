import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spotify_search/shared/exception.dart';
import 'package:flutter_spotify_search/domain/entities/token/token.dart';

abstract class TokenRemoteDataSource {
  Future<Token> getToken({
    required String clientId,
    required String clientSecret,
  });
}

class TokenRemoteDataSourceImpl implements TokenRemoteDataSource {
  final baseUrl = 'https://accounts.spotify.com/api/token';
  
  TokenRemoteDataSourceImpl();

  @override
  Future<Token> getToken({
    required String clientId,
    required String clientSecret,
  }) async {
    try {
      var credentials = utf8.encode('$clientId:$clientSecret');
      var encodedCredentials = base64.encode(credentials);

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Basic $encodedCredentials',
        },
        body: <String, String>{
          'grant_type': 'client_credentials',
        },
      );
      final decodedRes = jsonDecode(response.body);
      switch (response.statusCode) {
        case 200:
          return Token(
            accessToken: decodedRes['access_token'],
            tokenType: decodedRes['token_type'],
            expiresIn: decodedRes['expires_in'],
          );
        case 400:
          throw ServerException(message: 'Bad Request');
        case 401:
          throw ServerException(message: 'Unathorized');
        case 500:
          throw ServerException(message: 'Internal Server Error');
        default:
          throw ServerException(message: 'Error');
      }
    } on TypeError catch (_) {
      throw CastException(message: 'Cast Error');
    } on UnsupportedError catch (_) {
      throw ServerException(message: 'Server Error');
    } catch (e) {
      rethrow;
    }
  }
}
