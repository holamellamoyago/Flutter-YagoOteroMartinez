import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/auth_controller.dart';
import '../controllers/friends_controller.dart';
import '../theme/hw_theme.dart';
import 'login_screen.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    if (AuthController.to.isLoggedIn.value) {
      FriendsController.to.load();
    }
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  void _showSearch() {
    final ctrl = TextEditingController();
    final friendsCtrl = FriendsController.to;

    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: ctrl,
                decoration: const InputDecoration(
                  hintText: 'Search by name...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (q) => friendsCtrl.searchUsers(q),
                autofocus: true,
              ),
            ),
            Expanded(
              child: Obx(() {
                if (friendsCtrl.searching.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (friendsCtrl.searchResults.isEmpty) {
                  return const Center(child: Text('No users found'));
                }
                return ListView.builder(
                  itemCount: friendsCtrl.searchResults.length,
                  itemBuilder: (ctx, i) {
                    final user = friendsCtrl.searchResults[i];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: user['avatar_url'] != null
                            ? CachedNetworkImageProvider(user['avatar_url'])
                            : null,
                        child: user['avatar_url'] == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(user['display_name'] ?? 'Unknown'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          friendsCtrl.sendRequest(user['id']);
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HwTheme.orange,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text('Add', style: TextStyle(fontSize: 12)),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthController.to;

    if (!auth.isLoggedIn.value) {
      return Scaffold(
        appBar: AppBar(title: const Text('Friends')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.people_outline,
                  size: 64, color: HwTheme.orange.withAlpha(80)),
              const SizedBox(height: 16),
              const Text('Sign in to connect with friends'),
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
      appBar: AppBar(
        title: const Text('Friends'),
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: HwTheme.orange,
          tabs: const [
            Tab(text: 'Friends'),
            Tab(text: 'Requests'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _showSearch,
          ),
        ],
      ),
      body: Obx(() {
        final ctrl = FriendsController.to;
        if (ctrl.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return TabBarView(
          controller: _tabCtrl,
          children: [
            // Friends tab
            ctrl.friends.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.people_outline,
                            size: 64,
                            color: HwTheme.orange.withAlpha(80)),
                        const SizedBox(height: 16),
                        const Text('No friends yet'),
                        const SizedBox(height: 8),
                        Text('Tap + to search for users',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => ctrl.load(),
                    color: HwTheme.orange,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: ctrl.friends.length,
                      itemBuilder: (ctx, i) {
                        final friend = ctrl.friends[i];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: friend['avatar_url'] != null
                                  ? CachedNetworkImageProvider(
                                      friend['avatar_url'])
                                  : null,
                              child: friend['avatar_url'] == null
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            title: Text(
                                friend['display_name'] ?? 'Unknown'),
                          ),
                        );
                      },
                    ),
                  ),

            // Requests tab
            ctrl.pendingRequests.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_add_disabled,
                            size: 64,
                            color: HwTheme.orange.withAlpha(80)),
                        const SizedBox(height: 16),
                        const Text('No pending requests'),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: ctrl.pendingRequests.length,
                    itemBuilder: (ctx, i) {
                      final req = ctrl.pendingRequests[i];
                      final profile = req['profiles'] as Map?;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: profile != null
                                ? null
                                : const Icon(Icons.person),
                            backgroundImage: profile?['avatar_url'] != null
                                ? CachedNetworkImageProvider(
                                    profile!['avatar_url'])
                                : null,
                          ),
                          title: Text(profile?['display_name'] ?? 'Unknown'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check,
                                    color: Colors.green),
                                onPressed: () => ctrl.acceptRequest(req['id']),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.red),
                                onPressed: () => ctrl.rejectRequest(req['id']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        );
      }),
    );
  }
}
