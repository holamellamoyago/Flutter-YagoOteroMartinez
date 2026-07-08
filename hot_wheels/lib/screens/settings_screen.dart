import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/auth_controller.dart';
import '../controllers/theme_controller.dart';
import '../theme/hw_theme.dart';
import 'home_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Appearance
          _SectionHeader(title: 'Appearance'),
          const SizedBox(height: 8),
          Obx(() => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: SwitchListTile(
                  secondary: Icon(
                    themeCtrl.isDark.value
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: HwTheme.orange,
                  ),
                  title: const Text('Dark mode'),
                  subtitle:
                      const Text('Switch between light and dark appearance'),
                  value: themeCtrl.isDark.value,
                  onChanged: (_) => themeCtrl.toggle(),
                  activeColor: HwTheme.orange,
                ),
              )),
          const SizedBox(height: 24),

          // App
          _SectionHeader(title: 'App'),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.cleaning_services_outlined,
            title: 'Clear Cache',
            subtitle: 'Free up storage space',
            onTap: () {
              PaintingBinding.instance.imageCache.clear();
              Get.snackbar('Done', 'Cache cleared',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green.shade900,
                  colorText: Colors.white);
            },
          ),
          const SizedBox(height: 24),

          // About
          _SectionHeader(title: 'About'),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.info_outline,
            title: 'Version',
            subtitle: '0.1.0',
            onTap: null,
          ),
          const SizedBox(height: 24),

          // Credits
          _SectionHeader(title: 'Credits'),
          const SizedBox(height: 8),
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Desarrollado por',
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text('Yago Otero Martínez',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _openLinkedIn(),
                      icon: const Icon(Icons.link, size: 18),
                      label: const Text('LinkedIn'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.blue.shade400),
                        foregroundColor: Colors.blue.shade300,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Logout
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await Get.find<AuthController>().signOut();
                Get.offAll(() => const HomeScreen());
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label:
                  const Text('Sign Out', style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openLinkedIn() async {
    const url = 'https://www.linkedin.com/in/yagooteromartinez/';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(title,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: HwTheme.orange,
              letterSpacing: 1)),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: HwTheme.orange),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: onTap != null
            ? const Icon(Icons.chevron_right, color: Colors.white38)
            : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
