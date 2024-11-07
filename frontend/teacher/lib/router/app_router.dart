import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../login_page.dart';
import '../main_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: "/login",
          page: LoginRoute.page,
          initial: true,
        ),
        AutoRoute(
          path: "/main/:className",
          page: MainRoute.page,
        ),
      ];
}
