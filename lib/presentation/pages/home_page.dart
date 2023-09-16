import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spotify_search/shared/constants/app_paddings.dart';
import 'package:flutter_spotify_search/shared/constants/app_spaces.dart';
import 'package:flutter_spotify_search/shared/constants/app_strings.dart';
import 'package:flutter_spotify_search/shared/theme/app_colors.dart';
import 'package:flutter_spotify_search/shared/widgets/app_category_button.dart';

import '../providers/app_theme_mode_provider.dart';
import '../providers/token_provider.dart';

@RoutePage()
class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(tokenProvider.notifier).getToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(appThemeModeProvider);
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.black,
                  ),
                  cursorColor: AppColors.black,
                  decoration: InputDecoration(
                    hintText: AppStrings.searchHint,
                    hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.lightGrey),
                    prefixIcon: const Icon(Icons.search, color: AppColors.lightGrey,),
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.extraLightGrey),
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
              Row(
                children: <Widget>[
                  AppCategoryButton(
                    text: 'Albums', 
                    actived: true,
                    onPressed: () {},
                  ),
                  AppSpaces.wSemiSmall,
                  AppCategoryButton(
                    text: 'Artists',
                    actived: false,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
