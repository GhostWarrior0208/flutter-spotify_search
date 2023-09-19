import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spotify_search/presentation/components/albums_list.dart';
import 'package:flutter_spotify_search/presentation/components/artists_list.dart';
import 'package:flutter_spotify_search/shared/constants/app_enums.dart';
import 'package:flutter_spotify_search/shared/constants/app_paddings.dart';
import 'package:flutter_spotify_search/shared/constants/app_spaces.dart';
import 'package:flutter_spotify_search/shared/constants/app_strings.dart';
import 'package:flutter_spotify_search/shared/theme/app_colors.dart';
import 'package:flutter_spotify_search/shared/widgets/app_category_button.dart';

import '../providers/app_theme_mode_provider.dart';
import '../providers/home_page_states_providers.dart';
import '../providers/token_provider.dart';
import '../providers/albums_provider.dart';
import '../providers/artists_provider.dart';

@RoutePage()
class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late TextEditingController _queryController;
  late int nextAlbumsOffset;
  late int nextArtistsOffset;

  @override
  void initState() {
    super.initState();
    nextAlbumsOffset = 0;
    nextArtistsOffset = 0;
    _queryController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(tokenProvider.notifier).getToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(appThemeModeProvider);
    final tokenState = ref.watch(tokenProvider);
    final selectedDataCategory = ref.watch(selectedDataCategoryProvider);
    ref.listen<ScrollPos>(albumsListScrollPositionProvider, (previous, next) {
      if (next == ScrollPos.bottom && tokenState is GetTokenSuccess) {
        ref.read(albumsProvider.notifier).searchData(
              accessToken: tokenState.token.accessToken,
              query: _queryController.text,
              type: DataCategory.album,
              offset: ++nextAlbumsOffset,
            );
      }
    });
    ref.listen<ScrollPos>(artistsListScrollPositionProvider, (previous, next) {
      if (next == ScrollPos.bottom && tokenState is GetTokenSuccess) {
        ref.read(artistsProvider.notifier).searchData(
              accessToken: tokenState.token.accessToken,
              query: _queryController.text,
              type: DataCategory.artist,
              offset: ++nextArtistsOffset,
            );
      }
    });
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: AppPaddings.semiSmall,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    AppStrings.search,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: themeMode == ThemeMode.dark
                        ? const Icon(Icons.nightlight)
                        : const Icon(Icons.light_mode),
                    iconSize: 30,
                    onPressed: () {
                      ref.read(appThemeModeProvider.notifier).toggleThemeMode();
                    },
                  ),
                ],
              ),
              AppSpaces.hNormal,
              SizedBox(
                height: 50,
                child: TextField(
                  controller: _queryController,
                  onChanged: (value) {
                    if (tokenState is GetTokenSuccess) {
                      if (tokenState.token.expiresIn.isBefore(DateTime.now())) {
                        ref.read(tokenProvider.notifier).getToken();
                      } else {
                        if (value.isNotEmpty) {
                          ref.read(albumsProvider.notifier).searchData(
                                accessToken: tokenState.token.accessToken,
                                query: value,
                                type: DataCategory.album,
                                offset: 0,
                              );
                          ref.read(artistsProvider.notifier).searchData(
                                accessToken: tokenState.token.accessToken,
                                query: value,
                                type: DataCategory.artist,
                                offset: 0,
                              );
                        } else {
                          ref.read(albumsProvider.notifier).clearAlbums();
                          ref.read(artistsProvider.notifier).clearArtists();
                        }
                        nextAlbumsOffset = 0;
                        nextArtistsOffset = 0;
                      }
                    }
                    setState(() {});
                  },
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.black,
                      ),
                  cursorColor: AppColors.black,
                  decoration: InputDecoration(
                    hintText: AppStrings.searchHint,
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.lightGrey),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.lightGrey,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: AppColors.extraLightGrey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.lightGrey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              AppSpaces.hNormal,
              _queryController.text.isNotEmpty
                  ? Row(
                      children: <Widget>[
                        AppCategoryButton(
                          text: 'Albums',
                          actived: selectedDataCategory == DataCategory.album,
                          onPressed: () {
                            ref
                                .read(selectedDataCategoryProvider.notifier)
                                .state = DataCategory.album;
                          },
                        ),
                        AppSpaces.wSemiSmall,
                        AppCategoryButton(
                          text: 'Artists',
                          actived: selectedDataCategory == DataCategory.artist,
                          onPressed: () {
                            ref
                                .read(selectedDataCategoryProvider.notifier)
                                .state = DataCategory.artist;
                          },
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              AppSpaces.hSemiSmall,
              Expanded(
                child: Consumer(builder: (context, ref, child) {
                  if (tokenState is GetTokenSuccess) {
                    return selectedDataCategory == DataCategory.album
                        ? const AlbumsList()
                        : const ArtistsList();
                  } else if (tokenState is GetTokenLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (tokenState is GetTokenError) {
                    return Center(
                      child: Text(
                        tokenState.errorMessage,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
