import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spotify_search/presentation/components/albums_list.dart';
import 'package:flutter_spotify_search/presentation/components/artists_list.dart';
import 'package:flutter_spotify_search/presentation/providers/artists_provider.dart';
import 'package:flutter_spotify_search/shared/constants/app_enums.dart';
import 'package:flutter_spotify_search/shared/constants/app_paddings.dart';
import 'package:flutter_spotify_search/shared/constants/app_spaces.dart';
import 'package:flutter_spotify_search/shared/constants/app_strings.dart';
import 'package:flutter_spotify_search/shared/theme/app_colors.dart';
import 'package:flutter_spotify_search/shared/widgets/app_category_button.dart';

import '../providers/app_theme_mode_provider.dart';
import '../providers/selected_data_category_provider.dart';
import '../providers/token_provider.dart';
import '../providers/albums_provider.dart';

@RoutePage()
class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late TextEditingController _queryController;

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(tokenProvider.notifier).getToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(appThemeModeProvider);
    final selectedDataCategory = ref.watch(selectedDataCategoryProvider);
    final tokenState = ref.watch(tokenProvider);
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
                      if (selectedDataCategory == DataCategory.album) {
                        ref.read(albumsProvider.notifier).searchData(
                              accessToken: tokenState.token.accessToken,
                              query: value,
                              type: DataCategory.album,
                              offset: 0,
                              limit: 50,
                            );
                      } else {
                        ref.read(artistsProvider.notifier).searchData(
                              accessToken: tokenState.token.accessToken,
                              query: value,
                              type: DataCategory.artist,
                              offset: 0,
                              limit: 50,
                            );
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

                            if (tokenState is GetTokenSuccess) {
                              ref.read(albumsProvider.notifier).searchData(
                                    accessToken: tokenState.token.accessToken,
                                    query: _queryController.text,
                                    type: DataCategory.album,
                                    offset: 0,
                                    limit: 50,
                                  );
                            }
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

                            if (tokenState is GetTokenSuccess) {
                              ref.read(artistsProvider.notifier).searchData(
                                    accessToken: tokenState.token.accessToken,
                                    query: _queryController.text,
                                    type: DataCategory.artist,
                                    offset: 0,
                                    limit: 50,
                                  );
                            }
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
