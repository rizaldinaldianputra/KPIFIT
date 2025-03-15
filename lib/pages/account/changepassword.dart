import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kpifit/config/colors.dart';
import 'package:kpifit/models/user.dart';
import 'package:kpifit/service/services.dart';
import 'package:kpifit/util/widget_appbar.dart';

final isLoadingProvider = StateProvider<bool>((ref) => false);
final oldPasswordVisibleProvider = StateProvider<bool>((ref) => false);
final newPasswordVisibleProvider = StateProvider<bool>((ref) => false);
final confirmPasswordVisibleProvider = StateProvider<bool>((ref) => false);

class ChangepasswordPage extends ConsumerStatefulWidget {
  UserModel? userModel;
  ChangepasswordPage({super.key, required this.userModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangepasswordPageState();
}

class _ChangepasswordPageState extends ConsumerState<ChangepasswordPage> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingProvider);
    final oldPasswordVisible = ref.watch(oldPasswordVisibleProvider);
    final newPasswordVisible = ref.watch(newPasswordVisibleProvider);
    final confirmPasswordVisible = ref.watch(confirmPasswordVisibleProvider);

    return Scaffold(
      appBar: buildGradientAppBar(context, 'Change Password'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: !oldPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Old Password',
                labelStyle: const TextStyle(color: Colors.black),
                prefixIcon: Icon(Icons.lock, color: secondaryColor),
                suffixIcon: IconButton(
                  icon: Icon(oldPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    ref.read(oldPasswordVisibleProvider.notifier).state =
                        !oldPasswordVisible;
                  },
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: secondaryColor, width: 1),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPasswordController,
              obscureText: !newPasswordVisible,
              decoration: InputDecoration(
                labelText: 'New Password',
                labelStyle: const TextStyle(color: Colors.black),
                prefixIcon: Icon(Icons.lock_outline, color: secondaryColor),
                suffixIcon: IconButton(
                  icon: Icon(newPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    ref.read(newPasswordVisibleProvider.notifier).state =
                        !newPasswordVisible;
                  },
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: secondaryColor, width: 1),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPasswordController,
              obscureText: !confirmPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: const TextStyle(color: Colors.black),
                prefixIcon: Icon(Icons.verified_user, color: secondaryColor),
                suffixIcon: IconButton(
                  icon: Icon(confirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    ref.read(confirmPasswordVisibleProvider.notifier).state =
                        !confirmPasswordVisible;
                  },
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: secondaryColor, width: 1),
                ),
              ),
            ),
            const SizedBox(height: 24),
            isLoading
                ? CircularProgressIndicator(color: primaryColor)
                : GestureDetector(
                    onTap: () async {
                      ref.read(isLoadingProvider.notifier).state = true;
                      try {
                        await CoreService(context).changePassword(
                          ref: ref,
                          user: widget.userModel!.username,
                          newPassword: newPasswordController.text,
                          oldPassword: oldPasswordController.text,
                          confirmPassword: confirmPasswordController.text,
                          context: context,
                        );
                      } catch (e) {
                      } finally {
                        ref.read(isLoadingProvider.notifier).state = false;
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [HexColor('#01A2E9'), HexColor('#274896')],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Simpan',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
