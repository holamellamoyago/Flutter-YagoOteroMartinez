import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controllers/auth_controller.dart';
import '../services/supabase_service.dart';
import '../theme/hw_theme.dart';
import 'home_screen.dart';
import 'settings_screen.dart';
import 'my_lists_screen.dart';
import 'friends_screen.dart';
import 'groups_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _service = SupabaseService();
  int _listCount = 0;
  int _carCount = 0;
  int _friendCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    try {
      final lists = await _service.getUserLists();
      final friends = await _service.getFriends();
      if (mounted) {
        setState(() {
          _listCount = lists.length;
          _carCount = lists.fold(0, (sum, l) => sum + l.carCount);
          _friendCount = friends.length;
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final client = Supabase.instance.client;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Obx(() {
        final user = auth.user.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final name = user.userMetadata?['full_name'] as String? ??
            user.email ??
            'User';
        final avatar = user.userMetadata?['avatar_url'] as String?;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: HwTheme.orange.withAlpha(30),
                backgroundImage: avatar != null
                    ? CachedNetworkImageProvider(avatar)
                    : null,
                child: avatar == null
                    ? Text(name[0].toUpperCase(),
                        style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: HwTheme.orange))
                    : null,
              ),
              const SizedBox(height: 16),
              Text(name, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(user.email ?? '',
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () => _showEditNameDialog(context, name),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit name'),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () =>
                        _showChangePassword(context, client, user.email ?? ''),
                    icon: const Icon(Icons.lock_outline, size: 16),
                    label: const Text('Password'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatCard(label: 'Lists', value: _listCount.toString()),
                  _StatCard(label: 'Cars', value: _carCount.toString()),
                  _StatCard(label: 'Friends', value: _friendCount.toString()),
                ],
              ),
              const SizedBox(height: 36),
              _NavOption(
                  icon: Icons.bookmark_outline,
                  label: 'My Lists',
                  onTap: () => Get.to(() => const MyListsScreen())),
              const SizedBox(height: 8),
              _NavOption(
                  icon: Icons.people_outline,
                  label: 'Friends',
                  onTap: () => Get.to(() => const FriendsScreen())),
              const SizedBox(height: 8),
              _NavOption(
                  icon: Icons.group_outlined,
                  label: 'Groups',
                  onTap: () => Get.to(() => const GroupsScreen())),
              const SizedBox(height: 8),
              _NavOption(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  onTap: () => Get.to(() => const SettingsScreen())),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await auth.signOut();
                    Get.offAll(() => const HomeScreen());
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text('Sign Out',
                      style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  void _showEditNameDialog(BuildContext context, String currentName) {
    final ctrl = TextEditingController(text: currentName);
    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        title: const Text('Edit Display Name'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (ctrl.text.trim().isEmpty) return;
              try {
                await Supabase.instance.client
                    .from('profiles')
                    .update({'display_name': ctrl.text.trim()})
                    .eq('id', Supabase.instance.client.auth.currentUser!.id);
                await Supabase.instance.client.auth.updateUser(
                  UserAttributes(data: {'full_name': ctrl.text.trim()}),
                );
                Get.back();
                Get.snackbar('Done', 'Name updated',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green.shade900,
                    colorText: Colors.white);
              } catch (e) {
                Get.snackbar('Error', e.toString(),
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xFFB71C1C),
                    colorText: const Color(0xFFFFFFFF));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePassword(
      BuildContext context, SupabaseClient client, String email) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        title: const Text('Change Password'),
        content: Text('We\'ll send a password reset link to $email',
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                await client.auth.resetPasswordForEmail(email);
                Get.back();
                Get.snackbar('Sent', 'Check your email for the reset link',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xFF1B5E20),
                    colorText: const Color(0xFFFFFFFF));
              } catch (e) {
                Get.snackbar('Error', e.toString(),
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xFFB71C1C),
                    colorText: const Color(0xFFFFFFFF));
              }
            },
            child: const Text('Send reset link'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: [
        Text(value,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: HwTheme.orange)),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ]),
    );
  }
}

class _NavOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _NavOption({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: HwTheme.orange),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right, color: Colors.white38),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tileColor: Theme.of(context).cardTheme.color,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
