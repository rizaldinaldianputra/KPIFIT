import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kpifit/models/olahraga.dart';
import 'package:kpifit/models/workout.dart';
import 'package:kpifit/pages/home.dart';
import 'package:kpifit/pages/login.dart';
import 'package:kpifit/pages/logo.dart';
import 'package:kpifit/pages/maps.dart';
import 'package:kpifit/pages/stopwatch.dart';
import 'package:kpifit/pages/workout/detail_workout.dart';

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
        path: '/detail',
        name: 'detail',
        builder: (BuildContext context, GoRouterState state) {
          WorkoutModel workoutModel =
              state.extra as WorkoutModel; // 👈 casting is important

          return DetailPage(
            workoutModel: workoutModel,
            index: state.uri.queryParameters['index'],
          );
        },
      ),
      GoRoute(
          path: '/stopwatch',
          name: 'stopwatch',
          builder: (BuildContext context, GoRouterState state) {
            SportModel sportModel =
                state.extra as SportModel; // 👈 casting is important
            return StopWatchPage(
              sportModel: sportModel,
            );
          },
          routes: <RouteBase>[
            GoRoute(
              path: '/map',
              name: 'map',
              builder: (BuildContext context, GoRouterState state) {
                SportModel sportModel =
                    state.extra as SportModel; // 👈 casting is important

                return MapPage(
                  timer: state.uri.queryParameters['timer']!,
                  sportModel: sportModel,
                );
              },
            ),
          ]),
    ],
  ),
]);
