import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/supabase_service.dart';
import '../theme/hw_theme.dart';

class GroupDetailScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  final bool isOwner;

  const GroupDetailScreen({
    super.key,
    required this.groupId,
    required this.groupName,
    this.isOwner = false,
  });

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  final _service = SupabaseService();
  List<Map<String, dynamic>> _members = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _members = await _service.getGroupMembers(widget.groupId);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showAddMember() {
    final ctrl = TextEditingController();
    List<Map<String, dynamic>> results = [];
    bool searching = false;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          height: Get.height * 0.6,
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
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
                    hintText: 'Search users...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (q) async {
                    if (q.trim().length < 2) return;
                    setSheetState(() => searching = true);
                    try {
                      results =
                          await _service.searchProfiles(q.trim());
                    } catch (_) {}
                    setSheetState(() => searching = false);
                  },
                  autofocus: true,
                ),
              ),
              Expanded(
                child: searching
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (ctx, i) {
                          final user = results[i];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  user['avatar_url'] != null
                                      ? CachedNetworkImageProvider(
                                          user['avatar_url'])
                                      : null,
                              child: user['avatar_url'] == null
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            title:
                                Text(user['display_name'] ?? 'Unknown'),
                            trailing: ElevatedButton(
                              onPressed: () async {
                                await _service.addMemberToGroup(
                                    widget.groupId, user['id']);
                                Get.back();
                                _load();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: HwTheme.orange),
                              child: const Text('Add',
                                  style: TextStyle(fontSize: 12)),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        actions: [
          if (widget.isOwner)
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: _showAddMember,
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              color: HwTheme.orange,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _members.length,
                itemBuilder: (ctx, i) {
                  final member = _members[i];
                  final profile = member['profiles'] as Map?;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: profile?['avatar_url'] != null
                            ? CachedNetworkImageProvider(
                                profile!['avatar_url'])
                            : null,
                        child: profile?['avatar_url'] == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(profile?['display_name'] ?? 'Unknown'),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
