import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import '../models/user_list.dart';
import '../services/supabase_service.dart';
import '../theme/hw_theme.dart';

class ListDetailScreen extends StatefulWidget {
  final UserList list;
  final bool isOwner;

  /// Optional: view a public list by ID (not owner)
  final String? listId;

  const ListDetailScreen({
    super.key,
    required this.list,
    this.isOwner = false,
    this.listId,
  });

  @override
  State<ListDetailScreen> createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  final _service = SupabaseService();
  List<ListCarEntry> _cars = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _cars = await _service.getListCars(widget.list.id);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _removeCar(ListCarEntry entry) async {
    await _service.removeCarFromList(
      widget.list.id,
      entry.carToyNum,
      entry.carModelName,
      entry.carYear,
    );
    _load();
  }

  void _share() async {
    if (!widget.list.isPublic) {
      await _service.updateList(widget.list.id, isPublic: true);
    }
    final link = 'https://hotwheels.app/list/${widget.list.id}';
    await Share.share(
      'Check out my Hot Wheels list: ${widget.list.name}\n$link',
      subject: widget.list.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.list.name),
        actions: [
          if (widget.isOwner)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _share,
            ),
        ],
      ),
      body: Column(
        children: [
          // Shared by banner
          if (!widget.isOwner)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: HwTheme.orange.withAlpha(25),
              child: const Row(
                children: [
                  Icon(Icons.share, color: HwTheme.orange, size: 18),
                  SizedBox(width: 8),
                  Text('Shared list — read only',
                      style: TextStyle(color: HwTheme.orange)),
                ],
              ),
            ),

          // Car grid
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _cars.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.directions_car,
                                size: 64,
                                color: HwTheme.orange.withAlpha(80)),
                            const SizedBox(height: 16),
                            const Text('No cars in this list'),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _load,
                        color: HwTheme.orange,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.72,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _cars.length,
                          itemBuilder: (ctx, i) {
                            final entry = _cars[i];
                            return Card(
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Expanded(
                                        child: entry.carImageUrl != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.vertical(
                                                        top:
                                                            Radius.circular(
                                                                12)),
                                                child: CachedNetworkImage(
                                                  imageUrl: entry.carImageUrl!,
                                                  fit: BoxFit.contain,
                                                  width: double.infinity,
                                                ),
                                              )
                                            : const Icon(
                                                Icons.directions_car,
                                                size: 40,
                                                color: Colors.white24),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(6),
                                        child: Text(
                                          entry.carModelName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (widget.isOwner)
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () => _removeCar(entry),
                                        child: Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius:
                                                BorderRadius.circular(11),
                                          ),
                                          child: const Icon(Icons.close,
                                              size: 14, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
