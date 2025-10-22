import 'package:english_mvvm_provider_clean/data/viewmodel/users_viewmodel.dart';
import 'package:english_mvvm_provider_clean/presentation/social_screen/widgets/general_table_widget.dart';
import 'package:english_mvvm_provider_clean/presentation/social_screen/widgets/podium_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UsersViewmodel socialProvider = Provider.of<UsersViewmodel>(
      context,
      listen: true,
    );

    if (socialProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PodiumListWidget(socialProvider: socialProvider),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Text(
                "General Table",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 32, color: Colors.black),
              ),
            ),
            GeneralTableWidget(socialViewmodel: socialProvider),
          ],
        ),
      ),
    );
  }
}
