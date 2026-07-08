import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../theme/hw_theme.dart';
import '../widgets/user_avatar.dart';

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
  final _memberIds = <String>{};
  bool _loading = true;

  String get _myId => Supabase.instance.client.auth.currentUser?.id ?? '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _members = await _service.getGroupMembers(widget.groupId);
      _memberIds.clear();
      for (final m in _members) _memberIds.add(m['user_id'] as String);
    } catch (_) {} finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showAddMember() {
    final ctrl = TextEditingController();
    List<Map<String, dynamic>> users = [];
    bool loading = true;

    Future<void> loadUsers({String? query}) async {
      users = query != null && query.trim().length >= 2
          ? await _service.searchProfiles(query.trim())
          : await _service.getFriends();
      users = users.where((u) {
        final id = (u['friend_id'] ?? u['id']) as String;
        return id != _myId && !_memberIds.contains(id);
      }).toList();
    }

    loadUsers().then((_) { if (mounted) setState(() => loading = false); });

    Get.bottomSheet(
      StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          height: Get.height * 0.65,
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.white24,
                    borderRadius: BorderRadius.circular(2))),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: ctrl,
                decoration: const InputDecoration(
                    hintText: 'Search or pick from friends...',
                    prefixIcon: Icon(Icons.search)),
                onChanged: (q) async {
                  setSheetState(() => loading = true);
                  await loadUsers(query: q);
                  setSheetState(() => loading = false);
                },
              ),
            ),
            if (_members.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(children: [
                  Text('Members (${_members.length})',
                      style: const TextStyle(fontSize: 12,
                          fontWeight: FontWeight.w600, color: HwTheme.orange)),
                ]),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 56,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _members.length,
                  itemBuilder: (_, i) {
                    final p = _members[i]['profiles'] as Map?;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(children: [
                        UserAvatar(
                            imageUrl: p?['avatar_url'],
                            displayName: p?['display_name'],
                            radius: 16),
                        Text(p?['display_name']?.toString() ?? '',
                            style: const TextStyle(fontSize: 10)),
                      ]),
                    );
                  },
                ),
              ),
              const Divider(height: 24),
            ],
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : users.isEmpty
                      ? Center(child: Text(
                          ctrl.text.trim().length >= 2 ? 'No users found' : 'No friends to add',
                          style: const TextStyle(color: Colors.white54)))
                      : ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (_, i) {
                            final u = users[i];
                            final id = (u['friend_id'] ?? u['id']) as String;
                            final name = (u['display_name'] ?? 'Unknown') as String;
                            return ListTile(
                              leading: UserAvatar(
                                  imageUrl: u['avatar_url'],
                                  displayName: u['display_name']),
                              title: Text(name),
                              trailing: _memberIds.contains(id)
                                  ? const Chip(
                                      label: Text('Added',
                                          style: TextStyle(fontSize: 11, color: HwTheme.orange)),
                                      backgroundColor: Color(0x1AFF6B00),
                                      side: BorderSide.none)
                                  : ElevatedButton(
                                      onPressed: () async {
                                        await _service.addMemberToGroup(widget.groupId, id);
                                        _memberIds.add(id);
                                        setSheetState(() {});
                                        _load();
                                        Get.snackbar('Added', '$name added to group',
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: const Color(0xFF1B5E20),
                                            colorText: Colors.white);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: HwTheme.orange,
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6)),
                                      child: const Text('Add', style: TextStyle(fontSize: 12))),
                            );
                          },
                        ),
            ),
          ]),
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
            IconButton(icon: const Icon(Icons.person_add), onPressed: _showAddMember),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load, color: HwTheme.orange,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _members.length,
                itemBuilder: (_, i) {
                  final p = _members[i]['profiles'] as Map?;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: UserAvatar(
                          imageUrl: p?['avatar_url'],
                          displayName: p?['display_name']),
                      title: Text(p?['display_name'] ?? 'Unknown'),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
