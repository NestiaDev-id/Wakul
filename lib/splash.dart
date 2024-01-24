import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: AspectRatio(
                aspectRatio: 1 / 3,
                child: Image.asset(
                  'images/logo-no-background.png',
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Flexible(
              flex: 1,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
