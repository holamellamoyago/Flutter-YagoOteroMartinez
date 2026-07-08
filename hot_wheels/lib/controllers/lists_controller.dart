import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_list.dart';
import '../services/supabase_service.dart';

class ListsController extends GetxController {
  final _service = SupabaseService();
  final lists = <UserList>[].obs;
  final loading = false.obs;

  static ListsController get to => Get.find<ListsController>();

  Future<void> load() async {
    loading.value = true;
    try {
      lists.value = await _service.getUserLists();
    } catch (_) {
    } finally {
      loading.value = false;
    }
  }

  Future<void> createList(String name, String desc, {bool isPublic = false}) async {
    try {
      await _service.createList(name, description: desc, isPublic: isPublic);
      await load();
      Get.snackbar('Success', 'List "$name" created',
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

  Future<void> updateList(String id, {String? name, String? description, bool? isPublic}) async {
    try {
      await _service.updateList(id, name: name, description: description, isPublic: isPublic);
      await load();
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFB71C1C),
          colorText: const Color(0xFFFFFFFF));
    }
  }

  Future<void> deleteList(String id) async {
    try {
      await _service.deleteList(id);
      await load();
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFB71C1C),
          colorText: const Color(0xFFFFFFFF));
    }
  }

  void clear() => lists.clear();
}
