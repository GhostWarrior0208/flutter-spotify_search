import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spotify_search/data/datasource/data_remote_datasource.dart';
import 'package:flutter_spotify_search/data/repositories/data_repository_impl.dart';
import 'package:flutter_spotify_search/domain/entities/artist/artist.dart';
import 'package:flutter_spotify_search/domain/usecases/data_usecase.dart';
import 'package:flutter_spotify_search/shared/constants/app_enums.dart';
import 'package:flutter_spotify_search/shared/constants/app_strings.dart';
import 'package:flutter_spotify_search/shared/failure.dart';

final artistsProvider = NotifierProvider<ArtistsNotifier, GetArtistsState>(
  () {
    return ArtistsNotifier(
      usecase: DataUsecase(
          repository:
              DataRepositoryImpl(remoteDataSource: DataRemoteDataSourceImpl(dio: Dio()))),
      storedArtists: [],
    );
  },
);

class ArtistsNotifier extends Notifier<GetArtistsState> {
  final DataUsecase usecase;
  List<Artist> storedArtists;

  ArtistsNotifier({
    required this.usecase,
    required this.storedArtists,
  }) : super();

  String _getErrorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      case CastFailure:
        return (failure as CastFailure).message;
      default:
        return AppStrings.unknownErr;
    }
  }

  void searchData({
    required String accessToken,
    required String query,
    required DataCategory type,
    String market = 'ES',
    int limit = 20,
    required int offset,
    String includeExternal = '',
  }) async {
    state = GetArtistsLoading();
    final results = await usecase.searchData(
      accessToken: accessToken,
      query: query,
      type: type,
      market: market,
      limit: limit,
      offset: offset,
      includeExternal: includeExternal,
    );
    results.fold((failure) {
      state = GetArtistsError(errorMessage: _getErrorMessage(failure));
    }, (data) {
      if (offset == 0) {
        storedArtists = data as List<Artist>;
      } else {
        storedArtists.addAll(data as List<Artist>);
      }
      state = GetArtistsSuccess(artists: storedArtists);
    });
  }

  void clearArtists() {
    state = GetArtistsSuccess(artists: const []);
  }

  @override
  GetArtistsState build() {
    return GetArtistsInitial();
  }
}

abstract class GetArtistsState extends Equatable {}

class GetArtistsInitial extends GetArtistsState {
  @override
  List<Object?> get props => [];
}

class GetArtistsLoading extends GetArtistsState {
  @override
  List<Object?> get props => [];
}

class GetArtistsSuccess extends GetArtistsState {
  final List<Artist> artists;

  GetArtistsSuccess({required this.artists});

  @override
  List<Object?> get props => [artists];
}

class GetArtistsError extends GetArtistsState {
  final String errorMessage;

  GetArtistsError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
