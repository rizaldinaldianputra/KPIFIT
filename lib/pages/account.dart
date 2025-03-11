import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kpifit/config/colors.dart';
import 'package:kpifit/routing/route.dart';
import 'package:kpifit/util/widget_button.dart';

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            flexibleSpace: Container(
                decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [HexColor('#01A2E9'), HexColor('#274896')],
          ),
        ))),
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
                      SizedBox(
                        height: 70,
                        width: 70,
                        child: CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage('assets/profile.jpg')),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Rizaldi Naldian Putra',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'IT SUPPORT',
                        style: TextStyle(color: Colors.white, fontSize: 14),
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
                        // Aksi ketika diklik
                      }),
                      listTile(Icons.lock, 'Change Password', () {
                        // Aksi ketika diklik
                      }),
                      listTile(Icons.notifications, 'Notifications', () {
                        // Aksi ketika diklik
                      }),
                      listTile(Icons.help, 'Help & Support', () {
                        // Aksi ketika diklik
                      }),
                      listTile(Icons.dashboard_customize_outlined, 'About', () {
                        // Aksi ketika diklik
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: button('Logout', () {
          context.goNamed('login');
        }, secondaryColor));
  }
}
