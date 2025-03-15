import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kpifit/config/colors.dart';
import 'package:kpifit/models/user.dart';
import 'package:kpifit/service/services.dart';

class ProfilePage extends ConsumerStatefulWidget {
  UserModel? userModel;
  ProfilePage({super.key, required this.userModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [HexColor('#01A2E9'), HexColor('#274896')],
            ),
          ),
        ),
        Container(
          height: 400,
          child: Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                leading: const Icon(Icons.business),
                title: const Text('Divisi'),
                subtitle: Text(widget.userModel?.divisi ?? 'Tidak ada divisi'),
              ),
              ListTile(
                leading: const Icon(Icons.work),
                title: const Text('Jabatan'),
                subtitle:
                    Text(widget.userModel?.jabatan ?? 'Tidak ada jabatan'),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Nama'),
                subtitle: Text(widget.userModel?.nama ?? 'Tidak ada nama'),
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email'),
                subtitle: Text(widget.userModel?.email ?? 'Tidak ada email'),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
