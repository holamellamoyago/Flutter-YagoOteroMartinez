import 'package:english_mvvm_provider_clean/data/viewmodel/social_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SocialViewmodel socialProvider = Provider.of<SocialViewmodel>(
      context,
      listen: false,
    );
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Social screen", style: TextStyle(color: Colors.black)),
            FilledButton(
              onPressed: () => socialProvider.getGeneralTable(),
              child: Text("Coger users"),
            ),
          ],
        ),
      ),
    );
  }
}
