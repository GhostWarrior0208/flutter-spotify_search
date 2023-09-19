import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spotify_search/data/datasource/token_remote_datasource.dart';
import 'package:flutter_spotify_search/data/repositories/token_repository_impl.dart';
import 'package:flutter_spotify_search/domain/entities/token/token.dart';
import 'package:flutter_spotify_search/domain/usecases/token_usecase.dart';
import 'package:flutter_spotify_search/shared/constants/app_strings.dart';
import 'package:flutter_spotify_search/shared/failure.dart';
import 'package:flutter_spotify_search/config/config.dart';

final tokenProvider = NotifierProvider<TokenNotifier, GetTokenState>(
  () {
    return TokenNotifier(
        usecase: TokenUsecase(
            repository: TokenRepositoryImpl(
                remoteDataSource: TokenRemoteDataSourceImpl(dio: Dio()))),
        storedToken: null,
        clientId: clientId,
        clientSecret: clientSecret,
      );
  },
);

class TokenNotifier extends Notifier<GetTokenState> {
  final TokenUsecase usecase;
  Token? storedToken;
  final String clientId;
  final String clientSecret;
  TokenNotifier({
    required this.usecase,
    required this.storedToken,
    required this.clientId,
    required this.clientSecret,
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

  void getToken() async {
    state = GetTokenLoading();
    final results = await usecase.getToken(
      clientId: clientId,
      clientSecret: clientSecret,
    );
    results.fold((failure) {
      state = GetTokenError(errorMessage: _getErrorMessage(failure));
    }, (token) {
      storedToken = token;
      state = GetTokenSuccess(token: storedToken!);
    });
  }

  @override
  GetTokenState build() {
    return GetTokenInitial();
  }
}

abstract class GetTokenState extends Equatable {}

class GetTokenInitial extends GetTokenState {
  @override
  List<Object?> get props => [];
}

class GetTokenLoading extends GetTokenState {
  @override
  List<Object?> get props => [];
}

class GetTokenSuccess extends GetTokenState {
  final Token token;

  GetTokenSuccess({required this.token});

  @override
  List<Object?> get props => [token];
}

class GetTokenError extends GetTokenState {
  final String errorMessage;

  GetTokenError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
