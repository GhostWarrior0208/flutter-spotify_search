import 'package:auto_route/auto_route.dart';

import 'package:flutter_spotify_search/presentation/pages/home_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  final List<AutoRoute> routes = [
    CustomRoute(
        page: HomeRoute.page,
        path: '/',
        transitionsBuilder: TransitionsBuilders.fadeIn),
  ];
}
