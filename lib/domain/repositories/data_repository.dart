import 'package:dartz/dartz.dart';
import 'package:flutter_spotify_search/shared/failure.dart';
import 'package:flutter_spotify_search/shared/constants/app_enums.dart';

abstract class DataRepository {
  Future<Either<Failure, dynamic>> searchData({
    required String accessToken,
    required String query,
    required DataCategory type,
    String market = 'ES',
    int limit = 20,
    required int offset,
    String  includeExternal = '',
  });
}
