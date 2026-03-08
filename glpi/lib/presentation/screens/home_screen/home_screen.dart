import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glpi/presentation/controllers/glpi_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GlpiController>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home screen'),
            FilledButton(
              onPressed: () {
                controller.getAssets();
              },
              child: Text('Get Assets'),
            ),
          ],
        ),
      ),
    );
  }
}
