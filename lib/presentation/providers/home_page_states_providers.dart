import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spotify_search/shared/constants/app_enums.dart';

final selectedDataCategoryProvider = StateProvider<DataCategory>((ref) => DataCategory.album);

final albumsListScrollPositionProvider = StateProvider<ScrollPos>((ref) => ScrollPos.top);

final artistsListScrollPositionProvider = StateProvider<ScrollPos>((ref) => ScrollPos.top);