import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'main.dart';

final routerProvider = Provider<GoRouter>(
    (ref) => GoRouter(debugLogDiagnostics: true, routes: <RouteBase>[
          GoRoute(
            path: '/',
            builder: (context, state) =>
                MyHomePage(title: 'Flutter Demo Home Page'),
          ),
          GoRoute(
            path: '/pod_player',
            builder: (context, state) =>
                MyHomePage(title: 'Flutter Demo Home Page'),
          ),
        ]));
