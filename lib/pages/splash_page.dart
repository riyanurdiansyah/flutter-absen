import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade600,
      body: const Center(
        child: FlutterLogo(
          size: 125,
        ),
      ),
    );
  }
}
