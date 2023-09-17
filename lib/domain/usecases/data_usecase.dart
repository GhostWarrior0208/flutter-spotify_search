import 'package:dartz/dartz.dart';
import 'package:flutter_spotify_search/shared/constants/app_enums.dart';
import 'package:flutter_spotify_search/shared/failure.dart';
import '../repositories/data_repository.dart';

class DataUsecase implements DataRepository {
  final DataRepository repository;

  DataUsecase({required this.repository});

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
    return await repository.searchData(
      accessToken: accessToken,
      query: query,
      type: type,
      market: market,
      limit: limit,
      offset: offset,
      includeExternal: includeExternal,
    );
  }
}
