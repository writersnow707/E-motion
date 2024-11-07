// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [DrawPage]
class DrawRoute extends PageRouteInfo<DrawRouteArgs> {
  DrawRoute({
    Key? key,
    required String className,
    required String username,
    List<PageRouteInfo>? children,
  }) : super(
          DrawRoute.name,
          args: DrawRouteArgs(
            key: key,
            className: className,
            username: username,
          ),
          rawPathParams: {
            'className': className,
            'username': username,
          },
          initialChildren: children,
        );

  static const String name = 'DrawRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<DrawRouteArgs>(
          orElse: () => DrawRouteArgs(
                className: pathParams.getString('className'),
                username: pathParams.getString('username'),
              ));
      return DrawPage(
        key: args.key,
        className: args.className,
        username: args.username,
      );
    },
  );
}

class DrawRouteArgs {
  const DrawRouteArgs({
    this.key,
    required this.className,
    required this.username,
  });

  final Key? key;

  final String className;

  final String username;

  @override
  String toString() {
    return 'DrawRouteArgs{key: $key, className: $className, username: $username}';
  }
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    Key? key,
    required String className,
    List<PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            className: className,
          ),
          rawPathParams: {'className': className},
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<LoginRouteArgs>(
          orElse: () =>
              LoginRouteArgs(className: pathParams.getString('className')));
      return LoginPage(
        key: args.key,
        className: args.className,
      );
    },
  );
}

class LoginRouteArgs {
  const LoginRouteArgs({
    this.key,
    required this.className,
  });

  final Key? key;

  final String className;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, className: $className}';
  }
}
