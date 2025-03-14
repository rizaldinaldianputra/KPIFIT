import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kpifit/config/colors.dart';
import 'package:kpifit/service/services.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordObscure = false;
  bool isLoading = false;
  late CoreService coreService;

  @override
  void initState() {
    coreService = CoreService(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor],
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              margin: const EdgeInsets.all(16),
              height: 450,
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/favicon.png',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Sign In Aplikasi',
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Colors.black,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintStyle: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: HexColor('#A5A5A5'),
                          ),
                        ),
                        hintText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: primaryColor, width: 1),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _isPasswordObscure,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: HexColor('#A5A5A5'),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: primaryColor, width: 1),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            color: Colors.grey,
                            _isPasswordObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordObscure = !_isPasswordObscure;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: isLoading
                        ? null
                        : () async {
                            // await doLogin(
                            //   _emailController.text,
                            //   _passwordController.text,
                            // );
                            context.goNamed('home');
                          },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(200),
                        ),
                        color: isLoading ? Colors.grey : HexColor('#01A2E9'),
                      ),
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text(
                                'Sign In',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  doLogin(String username, String passwrod) {
    try {
      setState(() {
        isLoading = true;
      });
      coreService.login(username, passwrod, context);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
