import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controllers/auth_controller.dart';
import '../theme/hw_theme.dart';
import 'profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _navigating = false;

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: SafeArea(
        child: Obx(() {
          // Navigate away once logged in
          if (auth.isLoggedIn.value && !_navigating) {
            _navigating = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.off(() => const ProfileScreen());
            });
          }

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [HwTheme.orange, HwTheme.flame],
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(Icons.local_fire_department,
                        size: 56, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text('Hot Wheels',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Sign in to save your collection',
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 40),

                  // Google
                  _ProviderButton(
                    icon: 'assets/google_icon.png',
                    label: 'Continue with Google',
                    onTap: () => auth.signInWithGoogle(),
                  ),
                  const SizedBox(height: 12),

                  // Apple (iOS only)
                  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) ...[
                    _ProviderButton(
                      icon: 'assets/apple_icon.png',
                      label: 'Continue with Apple',
                      onTap: () => auth.signInWithApple(),
                      isDark: true,
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Email
                  _ProviderButton(
                    icon: null,
                    iconData: Icons.email_outlined,
                    label: 'Continue with Email',
                    onTap: () => _showEmailDialog(context),
                    isOutlined: true,
                  ),
                  const SizedBox(height: 40),
                  Text('By signing in you agree to our Terms of Service',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void _showEmailDialog(BuildContext context) {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        title: const Text('Sign in with Email'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailCtrl,
                decoration: const InputDecoration(
                    labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: passCtrl,
                decoration: const InputDecoration(
                    labelText: 'Password', prefixIcon: Icon(Icons.lock_outlined)),
                obscureText: true,
                validator: (v) =>
                    (v == null || v.length < 6) ? 'Min 6 characters' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                await Supabase.instance.client.auth.signInWithPassword(
                  email: emailCtrl.text.trim(),
                  password: passCtrl.text,
                );
                Get.back();
              } on AuthException catch (e) {
                Get.back();
                Get.snackbar('Error', e.message,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red.shade900,
                    colorText: Colors.white);
              }
            },
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}

class _ProviderButton extends StatelessWidget {
  final String? icon;
  final IconData? iconData;
  final String label;
  final VoidCallback? onTap;
  final bool isDark;
  final bool isOutlined;

  const _ProviderButton({
    this.icon, this.iconData, required this.label,
    this.onTap, this.isDark = false, this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isOutlined ? Colors.transparent : (isDark ? Colors.black : Colors.white),
          foregroundColor: isDark ? Colors.white : Colors.black87,
          side: isOutlined ? BorderSide(color: Theme.of(context).dividerColor) : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: isOutlined ? 0 : 1,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Image.asset(icon!, width: 24, height: 24)
            else if (iconData != null)
              Icon(iconData, size: 24),
            const SizedBox(width: 12),
            Text(label,
                style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w500,
                  color: isOutlined
                      ? Theme.of(context).textTheme.bodyMedium?.color
                      : (isDark ? Colors.white : Colors.black87),
                )),
          ],
        ),
      ),
    );
  }
}
