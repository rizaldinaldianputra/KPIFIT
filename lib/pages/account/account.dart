import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kpifit/models/user.dart';
import 'package:kpifit/service/services.dart';
import 'package:kpifit/util/widget_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  bool isLoading = true;

  UserModel user = UserModel.blank();

  @override
  void initState() {
    loadUser();
    super.initState();
  }

  Future<void> loadUser() async {
    UserModel fetchedUser = await CoreService(context).getUserFromPrefs();
    print('ini hasil ' + fetchedUser.nama);
    setState(() {
      user = fetchedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [HexColor('#01A2E9'), HexColor('#274896')],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [HexColor('#01A2E9'), HexColor('#274896')],
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 70,
                      width: 70,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/profile.jpg'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      user?.nama ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      (user?.divisi ?? '') + ('-' + (user?.jabatan ?? '')),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    listTile(Icons.person, 'Profile', () {
                      context.goNamed('profile', extra: user);
                    }),
                    listTile(Icons.lock, 'Change Password', () {
                      context.goNamed('changepassword', extra: user);
                    }),
                    listTile(Icons.notifications, 'Notifications', () {
                      context.goNamed('notikasi');
                    }),
                    listTile(Icons.help, 'Help & Support', () {
                      context.goNamed('help');
                    }),
                    listTile(Icons.dashboard_customize_outlined, 'About', () {
                      context.goNamed('about');
                    }),
                    listTile(Icons.logout, 'Logout', () async {
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();

                      sharedPreferences.remove('nik');
                      context.goNamed('login');
                    }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
