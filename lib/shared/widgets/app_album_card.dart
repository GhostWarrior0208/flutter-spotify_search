import 'package:flutter/material.dart';
import 'package:flutter_spotify_search/shared/constants/app_spaces.dart';
import 'package:flutter_spotify_search/shared/theme/app_colors.dart';

class AppAlbumCard extends StatelessWidget {
  const AppAlbumCard({
    required this.imageUrl,
    required this.albumName,
    required this.albumType,
    required this.artistNames,
    required this.releaseDate,
    super.key,
  });

  final String imageUrl;
  final String albumName;
  final String albumType;
  final List<String> artistNames;
  final String releaseDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Image.network(
          imageUrl,
          fit: BoxFit.fill,
        ),
        AppSpaces.hSemiSmall,
        Text(
          albumName,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        AppSpaces.hExtraSmall,
        Text(
          artistNames.join(', '),
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.lightGrey),
        ),
        AppSpaces.hExtraSmall,
        Text(
          '${albumType.substring(0, 1).toUpperCase() + albumType.substring(1).toLowerCase()} ${releaseDate.split('-').first}',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.extraLightGrey),
        ),
      ],
    );
  }
}
