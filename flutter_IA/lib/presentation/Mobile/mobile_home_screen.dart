import 'package:flutter/material.dart';

class MobileScreen extends StatelessWidget {
  static const name = '/mobile_home_screen.dart';
  const MobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Hola'),
      ),
    );
  }
}
