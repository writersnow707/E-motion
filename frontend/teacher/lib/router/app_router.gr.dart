// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [MainPage]
class MainRoute extends PageRouteInfo<MainRouteArgs> {
  MainRoute({
    Key? key,
    required String className,
    List<PageRouteInfo>? children,
  }) : super(
          MainRoute.name,
          args: MainRouteArgs(
            key: key,
            className: className,
          ),
          rawPathParams: {'className': className},
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<MainRouteArgs>(
          orElse: () =>
              MainRouteArgs(className: pathParams.getString('className')));
      return MainPage(
        key: args.key,
        className: args.className,
      );
    },
  );
}

class MainRouteArgs {
  const MainRouteArgs({
    this.key,
    required this.className,
  });

  final Key? key;

  final String className;

  @override
  String toString() {
    return 'MainRouteArgs{key: $key, className: $className}';
  }
}
