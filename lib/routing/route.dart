import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kpifit/pages/home.dart';
import 'package:kpifit/pages/login.dart';
import 'package:kpifit/pages/logo.dart';
import 'package:kpifit/pages/maps.dart';
import 'package:kpifit/pages/stopwatch.dart';

final GoRouter router = GoRouter(initialLocation: '/', routes: <RouteBase>[
  GoRoute(
    path: '/',
    name: 'logo',
    builder: (BuildContext context, GoRouterState state) {
      return const LogoPag();
    },
  ),
  GoRoute(
    path: '/login',
    name: 'login',
    builder: (BuildContext context, GoRouterState state) {
      return const LoginPage();
    },
  ),
  GoRoute(
      path: '/home',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: <RouteBase>[
        GoRoute(
            path: '/stopwatch',
            name: 'stopwatch',
            builder: (BuildContext context, GoRouterState state) {
              return const StopWatchPage();
            },
            routes: <RouteBase>[
              GoRoute(
                path: '/map',
                name: 'map',
                builder: (BuildContext context, GoRouterState state) {
                  return const MapPage();
                },
              ),
            ]),
      ]),
]);
