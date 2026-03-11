import 'package:flutter/material.dart';
import 'package:flutter_ia/presentation/controllers/ia_controller.dart';
import 'package:get/get.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<IAController>();

    return Scaffold(
      body: FilledButton(onPressed: () => controller.sendMessage(), child: Text('send message'))
    );
  }
}