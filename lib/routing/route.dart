import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kpifit/models/aktifitas.dart';
import 'package:kpifit/models/olahraga.dart';
import 'package:kpifit/models/user.dart';
import 'package:kpifit/pages/account/about.dart';
import 'package:kpifit/pages/account/changepassword.dart';
import 'package:kpifit/pages/account/help.dart';
import 'package:kpifit/pages/account/notification.dart';
import 'package:kpifit/pages/account/profile.dart';
import 'package:kpifit/pages/home.dart';
import 'package:kpifit/pages/login.dart';
import 'package:kpifit/pages/logo.dart';
import 'package:kpifit/pages/maps.dart';
import 'package:kpifit/pages/stopwatch.dart';
import 'package:kpifit/pages/aktifitas/detail_aktifitas.dart';

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
        path: '/notikasi',
        name: 'notikasi',
        builder: (BuildContext context, GoRouterState state) {
          return NotificationPage();
        },
      ),
      GoRoute(
        path: '/changepassword',
        name: 'changepassword',
        builder: (BuildContext context, GoRouterState state) {
          UserModel userModel = state.extra as UserModel;

          return ChangepasswordPage(
            userModel: userModel,
          );
        },
      ),
      GoRoute(
        path: '/help',
        name: 'help',
        builder: (BuildContext context, GoRouterState state) {
          return HelpPage();
        },
      ),
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (BuildContext context, GoRouterState state) {
          return AboutPage();
        },
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (BuildContext context, GoRouterState state) {
          UserModel userModel = state.extra as UserModel;
          return ProfilePage(
            userModel: userModel,
          );
        },
      ),
      GoRoute(
        path: '/detail',
        name: 'detail',
        builder: (BuildContext context, GoRouterState state) {
          AktivitasModel workoutModel =
              state.extra as AktivitasModel; // 👈 casting is important

          return DetailPage(
            workoutModel: workoutModel,
            index: state.uri.queryParameters['index'],
            show: state.uri.queryParameters['show'],
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
                    latStart: state.uri.queryParameters['lat']!,
                    longStart: state.uri.queryParameters['long']!,
                    timer: state.uri.queryParameters['timer']!,
                    sportModel: sportModel,
                  );
                },
                routes: <RouteBase>[]),
          ]),
    ],
  ),
]);
