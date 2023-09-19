import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_spotify_search/domain/entities/token/token.dart';
import 'package:flutter_spotify_search/data/datasource/token_remote_datasource.dart';

import '../../fixtures/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late TokenRemoteDataSourceImpl tokenRemoteDataSourceImpl;

  setUp(() {
    mockDio = MockDio();
    tokenRemoteDataSourceImpl = TokenRemoteDataSourceImpl(dio: mockDio);
    registerFallbackValue(Uri());
  });

  void setUpMockDio(String fixtureName, int statusCode) {
    when(() => mockDio.post(any())).thenAnswer((invocation) async => Response(
        requestOptions: RequestOptions(path: "/api/token", method: "POST"),
        statusCode: statusCode,
        data: jsonDecode(fixtureData(fixtureName))));
  }

  String clientId = 'aerg698erg235aerg';
  String clientSecret = 'dxgwe7243gaserg3r';

  group(
    'Generate Access Token', 
    () {
      test(
        'Should return a token when a status code of 200 is recieved',
        () async {
          // Arrange
          setUpMockDio('token_model.json', 200);
          // Act
          final token =
              await tokenRemoteDataSourceImpl.getToken(clientId: clientId, clientSecret: clientSecret);
          // Assert
          expect(token, isA<Token>());
        },
      );
    },
  );
}