import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spotify_search/shared/constants/app_enums.dart';
import 'package:flutter_spotify_search/shared/theme/app_colors.dart';
import 'package:flutter_spotify_search/shared/widgets/app_album_card.dart';

import '../providers/app_theme_mode_provider.dart';
import '../providers/home_page_states_providers.dart';
import '../providers/albums_provider.dart';

class AlbumsList extends ConsumerStatefulWidget {
  const AlbumsList({super.key});

  @override
  ConsumerState<AlbumsList> createState() => _AlbumsListState();
}

class _AlbumsListState extends ConsumerState<AlbumsList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      if (currentScroll == maxScroll) {
        ref.read(albumsListScrollPositionProvider.notifier).state =
            ScrollPos.bottom;
      } else {
        ref.read(albumsListScrollPositionProvider.notifier).state =
            ScrollPos.middle;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final albumsState = ref.watch(albumsProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    
    return albumsState is GetAlbumsSuccess
        ? GridView.builder(
            controller: _scrollController,
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
