import 'package:flutter/material.dart';
import '../theme/hw_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_outline, size: 80, color: HwTheme.orange.withValues(alpha: 0.5)),
            const SizedBox(height: 20),
            const Text('Coming soon', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text('Account features will be available in a future update.',
                style: TextStyle(color: Colors.white70), textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
