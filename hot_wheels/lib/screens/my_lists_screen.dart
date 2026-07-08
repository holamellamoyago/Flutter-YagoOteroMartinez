import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/auth_controller.dart';
import '../controllers/lists_controller.dart';
import '../models/user_list.dart';
import '../theme/hw_theme.dart';
import 'list_detail_screen.dart';
import 'login_screen.dart';
import 'favorites_screen.dart';

class MyListsScreen extends StatefulWidget {
  const MyListsScreen({super.key});

  @override
  State<MyListsScreen> createState() => _MyListsScreenState();
}

class _MyListsScreenState extends State<MyListsScreen> {
  @override
  void initState() {
    super.initState();
    if (AuthController.to.isLoggedIn.value) {
      ListsController.to.load();
    }
  }

  void _showCreateDialog() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    bool isPublic = false;

    Get.dialog(
      StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: Theme.of(context).cardTheme.color,
          title: const Text('New List'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'List name',
                  hintText: 'e.g. Favorite Muscle Cars',
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
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Public list'),
                subtitle: const Text('Anyone with the link can view'),
                value: isPublic,
                onChanged: (v) => setDialogState(() => isPublic = v),
                activeColor: HwTheme.orange,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                ListsController.to.createList(
                  nameCtrl.text.trim(),
                  descCtrl.text.trim(),
                  isPublic: isPublic,
                );
                Get.back();
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptions(UserList list) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: HwTheme.orange),
              title: const Text('Rename'),
              onTap: () {
                Get.back();
                _showRenameDialog(list);
              },
            ),
            ListTile(
              leading: Icon(Icons.share,
                  color: list.isPublic ? HwTheme.orange : Colors.white38),
              title: const Text('Share'),
              onTap: () {
                Get.back();
                _shareList(list);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Get.back();
                final confirmed = await _confirmDelete(list.name);
                if (confirmed) {
                  ListsController.to.deleteList(list.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameDialog(UserList list) {
    final ctrl = TextEditingController(text: list.name);
    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        title: const Text('Rename List'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                ListsController.to.updateList(list.id, name: ctrl.text.trim());
                Get.back();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmDelete(String name) async {
    return await Get.dialog<bool>(
          AlertDialog(
            backgroundColor: Theme.of(context).cardTheme.color,
            title: const Text('Delete List?'),
            content: Text(
                'This will permanently delete "$name" and all its cars.'),
            actions: [
              TextButton(
                  onPressed: () => Get.back(result: false),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () => Get.back(result: true),
                  child: const Text('Delete',
                      style: TextStyle(color: Colors.red))),
            ],
          ),
        ) ??
        false;
  }

  void _shareList(UserList list) async {
    // Phase 4: deep link
    if (!list.isPublic) {
      await ListsController.to.updateList(list.id, isPublic: true);
    }
    final link = 'https://hotwheels.app/list/${list.id}';
    Get.snackbar('Link copied', link,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1B5E20),
        colorText: const Color(0xFFFFFFFF));
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthController.to;

    if (!auth.isLoggedIn.value) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Lists')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline,
                  size: 64, color: HwTheme.orange.withAlpha(80)),
              const SizedBox(height: 16),
              const Text('Sign in to create lists'),
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
      appBar: AppBar(title: const Text('My Lists')),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        backgroundColor: HwTheme.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(() {
        final ctrl = ListsController.to;
        if (ctrl.loading.value && ctrl.lists.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (ctrl.lists.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bookmark_outline,
                    size: 64, color: HwTheme.orange.withAlpha(80)),
                const SizedBox(height: 16),
                const Text('No lists yet'),
                const SizedBox(height: 8),
                Text('Tap + to create your first list!',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ctrl.load(),
          color: HwTheme.orange,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ctrl.lists.length + 1, // +1 for favorites
            itemBuilder: (ctx, i) {
              // Favorites special card
              if (i == 0) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: HwTheme.orange.withAlpha(20),
                  child: ListTile(
                    leading: Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          colors: [HwTheme.orange, HwTheme.flame],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      ),
                      child: const Icon(Icons.favorite, color: Colors.white),
                    ),
                    title: const Text('Coches favoritos',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('Your favorite cars',
                        style: Theme.of(context).textTheme.bodySmall),
                    trailing: const Icon(Icons.chevron_right, color: Colors.white38),
                    onTap: () => Get.to(() => const FavoritesScreen()),
                  ),
                );
              }

              final list = ctrl.lists[i - 1];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: HwTheme.orange.withAlpha(30),
                    ),
                    child: list.previewImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: list.previewImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.list, color: HwTheme.orange),
                  ),
                  title: Text(list.name),
                  subtitle: Text(
                    '${list.carCount} cars${list.isPublic ? ' · Public' : ''}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: const Icon(Icons.chevron_right,
                      color: Colors.white38),
                  onTap: () => Get.to(
                      () => ListDetailScreen(list: list, isOwner: true)),
                  onLongPress: () => _showOptions(list),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
