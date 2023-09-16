import 'package:dartz/dartz.dart';
import 'package:flutter_spotify_search/shared/failure.dart';
import '../entities/token/token.dart';
import '../repositories/token_repository.dart';

class TokenUsecase implements TokenRepository {
  final TokenRepository repository;

  TokenUsecase({required this.repository});
  
  @override
  Future<Either<Failure, Token>> getToken({required String clientId, required String clientSecret}) async {
    return await repository.getToken(clientId: clientId, clientSecret: clientSecret);
  }
}