import 'package:dartz/dartz.dart';
import 'package:flutter_spotify_search/shared/failure.dart';
import '../entities/token/token.dart';

abstract class TokenRepository {
  Future<Either<Failure, Token>> getToken({
    required String clientId,
    required String clientSecret,
  });
}
