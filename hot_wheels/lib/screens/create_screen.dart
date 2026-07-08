import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../theme/hw_theme.dart';
import 'login_screen.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = AuthController.to;

    if (!auth.isLoggedIn.value) {
      return Scaffold(
        appBar: AppBar(title: const Text('Create')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome,
                  size: 64, color: HwTheme.orange.withAlpha(80)),
              const SizedBox(height: 16),
              const Text('Sign in to create'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Get.to(() => const LoginScreen()),
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Create your Hot Wheel')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [HwTheme.orange, HwTheme.flame],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.auto_awesome,
                    size: 56, color: Colors.white),
              ),
              const SizedBox(height: 24),
              Text('Crea tu propio Hot Wheel',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text(
                'Sube una foto horizontal de tu coche y la IA lo convertirá en un Hot Wheel único.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.snackbar('Coming soon',
                        'This feature will be available soon!',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFF1B5E20),
                        colorText: Colors.white);
                  },
                  icon: const Icon(Icons.add_a_photo, color: HwTheme.orange),
                  label: const Text('Upload a photo'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: HwTheme.orange),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Powered by AI · Coming soon',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
