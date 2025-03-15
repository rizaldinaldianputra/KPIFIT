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
  UserModel? userModel;
  bool isLoading = true;

  Future<void> getMyProfile() async {
    try {
      UserModel? result = await CoreService(context).myProfile();
      if (mounted) {
        setState(() {
          userModel = result;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    getMyProfile();
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.blue,
            ))
          : Stack(
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
                            userModel?.nama ?? '',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 24),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            (userModel?.divisi ?? '') +
                                ('-' + (userModel?.jabatan ?? '')),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
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
                            context.goNamed('profile', extra: userModel);
                          }),
                          listTile(Icons.lock, 'Change Password', () {
                            context.goNamed('changepassword', extra: userModel);
                          }),
                          listTile(Icons.notifications, 'Notifications', () {
                            context.goNamed('notikasi');
                          }),
                          listTile(Icons.help, 'Help & Support', () {
                            context.goNamed('help');
                          }),
                          listTile(Icons.dashboard_customize_outlined, 'About',
                              () {
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
