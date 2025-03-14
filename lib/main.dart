import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kpifit/databases/hive.dart';
import 'package:kpifit/routing/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final routerConfig = router;

    return MaterialApp.router(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          surface: Colors.white,
          primary: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      routerDelegate: routerConfig.routerDelegate,
      routeInformationParser: routerConfig.routeInformationParser,
      routeInformationProvider: routerConfig.routeInformationProvider,
    );
  }
}
