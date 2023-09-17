import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_spotify_search/shared/constants/app_strings.dart';
import 'package:flutter_spotify_search/shared/exception.dart';
import 'package:flutter_spotify_search/domain/entities/token/token.dart';

abstract class TokenRemoteDataSource {
  Future<Token> getToken({
    required String clientId,
    required String clientSecret,
  });
}

class TokenRemoteDataSourceImpl implements TokenRemoteDataSource {
  final Dio dio;
  final baseUrl = 'https://accounts.spotify.com/api/token';
  
  TokenRemoteDataSourceImpl({required this.dio});

  @override
  Future<Token> getToken({
    required String clientId,
    required String clientSecret,
  }) async {
    try {
      var credentials = utf8.encode('$clientId:$clientSecret');
      var encodedCredentials = base64.encode(credentials);

      final response = await dio.post(
        baseUrl,
        options: Options(
          headers: <String, String>{
              'Authorization': 'Basic $encodedCredentials',
            },
          contentType: 'application/x-www-form-urlencoded',
        ),
        data: <String, String>{
          'grant_type': 'client_credentials',
        },
      );
      switch (response.statusCode) {
        case 200:
          return Token.fromJson(response.data);
        case 400:
          throw ServerException(message: AppStrings.badRequest);
        case 401:
          throw ServerException(message: AppStrings.badRequest);
        case 500:
          throw ServerException(message: AppStrings.interServerErr);
        default:
          throw ServerException(message: AppStrings.error);
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
