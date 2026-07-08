import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/supabase_service.dart';

class FriendsController extends GetxController {
  final _service = SupabaseService();
  final friends = <Map<String, dynamic>>[].obs;
  final pendingRequests = <Map<String, dynamic>>[].obs;
  final searchResults = <Map<String, dynamic>>[].obs;
  final loading = false.obs;
  final searching = false.obs;

  static FriendsController get to => Get.find<FriendsController>();

  Future<void> load() async {
    loading.value = true;
    try {
      friends.value = await _service.getFriends();
      pendingRequests.value = await _service.getPendingRequests();
    } catch (_) {
    } finally {
      loading.value = false;
    }
  }

  Future<void> searchUsers(String query) async {
    if (query.trim().length < 2) return;
    searching.value = true;
    try {
      searchResults.value = await _service.searchProfiles(query.trim());
    } catch (_) {
    } finally {
      searching.value = false;
    }
  }

  Future<void> sendRequest(String addresseeId) async {
    try {
      await _service.sendFriendRequest(addresseeId);
      Get.snackbar('Sent', 'Friend request sent',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1B5E20),
          colorText: const Color(0xFFFFFFFF));
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFB71C1C),
          colorText: const Color(0xFFFFFFFF));
    }
  }

  Future<void> acceptRequest(String friendshipId) async {
    try {
      await _service.respondToFriendRequest(friendshipId, 'accepted');
      await load();
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFB71C1C),
          colorText: const Color(0xFFFFFFFF));
    }
  }

  Future<void> rejectRequest(String friendshipId) async {
    try {
      await _service.respondToFriendRequest(friendshipId, 'rejected');
      await load();
    } catch (_) {}
  }

  void clear() {
    friends.clear();
    pendingRequests.clear();
    searchResults.clear();
  }
}
