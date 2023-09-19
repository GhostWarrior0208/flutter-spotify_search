import 'package:dartz/dartz.dart';
import 'package:flutter_spotify_search/shared/constants/app_enums.dart';
import 'package:flutter_spotify_search/shared/constants/app_strings.dart';
import 'package:flutter_spotify_search/shared/exception.dart';
import 'package:flutter_spotify_search/shared/failure.dart';
import 'package:flutter_spotify_search/domain/repositories/data_repository.dart';
import '../datasource/data_remote_datasource.dart';

class DataRepositoryImpl implements DataRepository {
  final DataRemoteDataSource remoteDataSource;

  DataRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, dynamic>> searchData({
    required String accessToken,
    required String query,
    required DataCategory type,
    String market = 'ES',
    int limit = 20,
    required int offset,
    String includeExternal = '',
  }) async {
    try {
      final data = await remoteDataSource.searchData(
        accessToken: accessToken,
        query: query,
        type: type,
        market: market,
        limit: limit,
        offset: offset,
        includeExternal: includeExternal,
      );
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CastException catch (e) {
      return Left(CastFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: AppStrings.badRequest));
    }
  }
}
