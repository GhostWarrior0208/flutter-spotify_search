import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spotify_search/data/datasource/data_remote_datasource.dart';
import 'package:flutter_spotify_search/data/repositories/data_repository_impl.dart';
import 'package:flutter_spotify_search/domain/entities/album/album.dart';
import 'package:flutter_spotify_search/domain/usecases/data_usecase.dart';
import 'package:flutter_spotify_search/shared/constants/app_enums.dart';
import 'package:flutter_spotify_search/shared/constants/app_strings.dart';
import 'package:flutter_spotify_search/shared/failure.dart';

final albumsProvider = NotifierProvider<AlbumsNotifier, GetAlbumsState>(
  () {
    return AlbumsNotifier(
      usecase: DataUsecase(
          repository:
              DataRepositoryImpl(remoteDataSource: DataRemoteDataSourceImpl(dio: Dio()))),
      storedAlbums: [],
    );
  },
);

class AlbumsNotifier extends Notifier<GetAlbumsState> {
  final DataUsecase usecase;
  List<Album> storedAlbums;

  AlbumsNotifier({
    required this.usecase,
    required this.storedAlbums,
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
    state = GetAlbumsLoading();
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
      state = GetAlbumsError(errorMessage: _getErrorMessage(failure));
    }, (albums) {
      storedAlbums = albums as List<Album>;
      state = GetAlbumsSuccess(albums: storedAlbums);
    });
  }

  void clearAlbums() {
    state = GetAlbumsSuccess(albums: const []);
  }

  @override
  GetAlbumsState build() {
    return GetAlbumsInitial();
  }
}

abstract class GetAlbumsState extends Equatable {}

class GetAlbumsInitial extends GetAlbumsState {
  @override
  List<Object?> get props => [];
}

class GetAlbumsLoading extends GetAlbumsState {
  @override
  List<Object?> get props => [];
}

class GetAlbumsSuccess extends GetAlbumsState {
  final List<Album> albums;

  GetAlbumsSuccess({required this.albums});

  @override
  List<Object?> get props => [albums];
}

class GetAlbumsError extends GetAlbumsState {
  final String errorMessage;

  GetAlbumsError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
