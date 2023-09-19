import 'package:dartz/dartz.dart';
import 'package:flutter_spotify_search/shared/constants/app_strings.dart';
import 'package:flutter_spotify_search/shared/exception.dart';
import 'package:flutter_spotify_search/shared/failure.dart';
import 'package:flutter_spotify_search/domain/entities/token/token.dart';
import 'package:flutter_spotify_search/domain/repositories/token_repository.dart';
import '../datasource/token_remote_datasource.dart';

class TokenRepositoryImpl implements TokenRepository {
  final TokenRemoteDataSource remoteDataSource;

  TokenRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Token>> getToken({
    required String clientId,
    required String clientSecret,
  }) async {
    try {
      final token = await remoteDataSource.getToken(
        clientId: clientId,
        clientSecret: clientSecret,
      );
      return Right(token);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CastException catch (e) {
      return Left(CastFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: AppStrings.badRequest));
    }
  }
}
