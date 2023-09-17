import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spotify_search/shared/theme/app_colors.dart';
import 'package:flutter_spotify_search/shared/widgets/app_album_card.dart';

import '../providers/app_theme_mode_provider.dart';
import '../providers/albums_provider.dart';

class AlbumsList extends ConsumerWidget {
  const AlbumsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumsState = ref.watch(albumsProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    return albumsState is GetAlbumsSuccess
        ? GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.69,
              crossAxisSpacing: 13,
              mainAxisSpacing: 15,
            ),
            itemCount: albumsState.albums.length,
            itemBuilder: (BuildContext context, int index) {
              return AppAlbumCard(
                imageUrl: albumsState.albums[index].imageUrl,
                albumType: albumsState.albums[index].albumType,
                albumName: albumsState.albums[index].albumName,
                artistNames: albumsState.albums[index].artistNames,
                releaseDate: albumsState.albums[index].releaseDate,
              );
            },
          )
        : albumsState is GetAlbumsLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: themeMode == ThemeMode.dark
                      ? const AlwaysStoppedAnimation<Color>(AppColors.white)
                      : const AlwaysStoppedAnimation<Color>(AppColors.black),
                ),
              )
            : albumsState is GetAlbumsError
                ? Center(
                    child: Text(
                      albumsState.errorMessage,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.extraLightGrey),
                    ),
                  )
                : const SizedBox.shrink();
  }
}
