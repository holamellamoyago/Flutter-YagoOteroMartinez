import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../services/supabase_service.dart';
import '../screens/list_detail_screen.dart';

/// Handles incoming deep links (hotwheels://list/{id})
/// and navigates to the appropriate screen.
class DeepLinkService {
  final _service = SupabaseService();

  Future<void> init() async {
    // Deep links via app_links will be implemented in Phase 4
    // For now, the pending link service handles post-login dispatch
  }

  Future<void> openList(String listId) async {
    final list = await _service.getPublicList(listId);
    if (list == null) {
      Get.snackbar('Not found', 'This list is no longer available',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFB71C1C),
          colorText: const Color(0xFFFFFFFF));
      return;
    }

    if (AuthController.to.isLoggedIn.value) {
      Get.to(() => ListDetailScreen(list: list, isOwner: false));
    } else {
      Get.to(() => ListDetailScreen(list: list, isOwner: false));
    }
  }
}
