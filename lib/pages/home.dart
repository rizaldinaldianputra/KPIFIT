import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kpifit/config/colors.dart';
import 'package:kpifit/models/user.dart';
import 'package:kpifit/pages/account/account.dart';
import 'package:kpifit/pages/beranda.dart';
import 'package:kpifit/pages/workout.dart';
import 'package:kpifit/riverpod/home.dart';
import 'package:kpifit/service/services.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  UserModel? user;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final fetchedUser = await CoreService(context).getUserFromPrefs();
    if (!_isDisposed && mounted) {
      setState(() {
        user = fetchedUser;
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(homePageProvider);

    final List<Widget> pages = [
      BerandaPage(userModel: user ?? UserModel.blank()),
      const WorkOutPage(),
      const AccountPage(),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => ref.read(homePageProvider.notifier).setPage(index),
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center), label: "Workout"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}
