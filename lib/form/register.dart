import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wakul2/Form/login.dart';
import 'package:wakul2/controller/firebase_auth_service.dart';
import 'package:wakul2/form/input_widget.dart';
import 'package:get/get.dart';
import 'package:wakul2/controller/authentication.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuthService auth = FirebaseAuthService();

  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());

  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _slideAnimation = Tween<Offset>(
      begin: const Offset(2, 0),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 750),
        )..forward(),
        curve: Curves.easeInCubic,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenheight,
              width: screenWidth,
              decoration: const BoxDecoration(color: Color((0xFFFAD677))),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: MediaQuery.of(context).size.height * 0.5 -
                        (screenWidth / 1.65),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 500),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: child,
                        );
                      },
                      child: SizedBox(
                        height: 75,
                        child: Image.asset('images/logo.png'),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.6,
                      decoration: const ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(61),
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 2500),
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: child,
                              );
                            },
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: const Text(
                                'Daftar',
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 1800),
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: child,
                              );
                            },
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: SizedBox(
                                width: 250,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: InputField(
                                        labelText: 'Username',
                                        controller: usernameController,
                                        obscureText: false,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: InputField(
                                        labelText: 'Email',
                                        controller: emailController,
                                        obscureText: false,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: InputField(
                                        labelText: 'Password',
                                        controller: passwordController,
                                        obscureText: true,
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Obx(
                                          () => auth.isLoading.value
                                              ? const CircularProgressIndicator()
                                              : ElevatedButton(
                                                  onPressed: () async {
                                                    await auth.registrasi(
                                                      username:
                                                          usernameController
                                                              .text
                                                              .trim(),
                                                      email: emailController
                                                          .text
                                                          .trim(),
                                                      password:
                                                          passwordController
                                                              .text
                                                              .trim(),
                                                    );
                                                    if (auth.errorMessage
                                                        .isNotEmpty) {
                                                      showModal(context);
                                                    }
                                                  },
                                                  style: ElevatedButton
                                                      .styleFrom(),
                                                  child: const Text("Daftar"),
                                                ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text('Sudah Punya Akun?'),
                                            TextButton(
                                              child: const Text('Login'),
                                              onPressed: () {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return const LoginPage();
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
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
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> showModal(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Register Status',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                auth.errorMessage.value,
                textAlign: TextAlign.center, // Center-align the text
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
