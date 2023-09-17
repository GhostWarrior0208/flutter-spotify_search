import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spotify_search/shared/constants/app_paddings.dart';
import 'package:flutter_spotify_search/shared/constants/app_spaces.dart';
import 'package:flutter_spotify_search/shared/theme/app_colors.dart';

import '../providers/app_theme_mode_provider.dart';
import '../providers/artists_provider.dart';

class ArtistsList extends ConsumerWidget {
  const ArtistsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artistsState = ref.watch(artistsProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    return artistsState is GetArtistsSuccess
        ? SingleChildScrollView(
            child: Column(
              children: List.generate(artistsState.artists.length, (index) {
                return Padding(
                  padding: AppPaddings.hSmall,
                  child: Row(
                    children: [
                      artistsState.artists[index].imageUrl.isNotEmpty
                          ? CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  artistsState.artists[index].imageUrl),
                            )
                          : CircleAvatar(
                              backgroundColor: AppColors.green,
                              radius: 30,
                              child: Text(
                                artistsState.artists[index].artistName
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                      AppSpaces.wSemiBig,
                      Expanded(
                        child: Text(
                          artistsState.artists[index].artistName,
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          )
        : artistsState is GetArtistsLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: themeMode == ThemeMode.dark
                      ? const AlwaysStoppedAnimation<Color>(AppColors.white)
                      : const AlwaysStoppedAnimation<Color>(AppColors.black),
                ),
              )
            : artistsState is GetArtistsError
                ? Center(
                    child: Text(
                      artistsState.errorMessage,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.extraLightGrey),
                    ),
                  )
                : const SizedBox.shrink();
  }
}
