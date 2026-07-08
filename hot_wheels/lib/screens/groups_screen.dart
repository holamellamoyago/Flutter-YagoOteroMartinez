import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../services/supabase_service.dart';
import '../theme/hw_theme.dart';
import 'group_detail_screen.dart';
import 'login_screen.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final _service = SupabaseService();
  List<Map<String, dynamic>> _groups = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!AuthController.to.isLoggedIn.value) return;
    setState(() => _loading = true);
    try {
      _groups = await _service.getUserGroups();
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showCreateDialog() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        title: const Text('New Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Group name',
                hintText: 'e.g. HW Collectors',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              try {
                await _service.createGroup(nameCtrl.text.trim(),
                    description: descCtrl.text.trim());
                Get.back();
                _load();
              } catch (e) {
                Get.snackbar('Error', e.toString(),
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xFFB71C1C),
                    colorText: const Color(0xFFFFFFFF));
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthController.to;

    if (!auth.isLoggedIn.value) {
      return Scaffold(
        appBar: AppBar(title: const Text('Groups')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.group_outlined,
                  size: 64, color: HwTheme.orange.withAlpha(80)),
              const SizedBox(height: 16),
              const Text('Sign in to join groups'),
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
      appBar: AppBar(title: const Text('Groups')),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        backgroundColor: HwTheme.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _groups.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.group_outlined,
                          size: 64, color: HwTheme.orange.withAlpha(80)),
                      const SizedBox(height: 16),
                      const Text('No groups yet'),
                      const SizedBox(height: 8),
                      Text('Create one to share lists!',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  color: HwTheme.orange,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _groups.length,
                    itemBuilder: (ctx, i) {
                      final group = _groups[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: HwTheme.orange.withAlpha(30),
                            child: const Icon(Icons.group,
                                color: HwTheme.orange),
                          ),
                          title: Text(group['name'] ?? ''),
                          subtitle: Text(group['description'] ?? '',
                              style: Theme.of(context).textTheme.bodySmall),
                          onTap: () => Get.to(() => GroupDetailScreen(
                              groupId: group['id'],
                              groupName: group['name'] ?? '',
                              isOwner: group['owner_id'] ==
                                  AuthController.to.user.value?.id)),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
