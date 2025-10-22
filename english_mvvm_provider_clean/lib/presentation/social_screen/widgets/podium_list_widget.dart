import 'package:english_mvvm_provider_clean/data/viewmodel/users_viewmodel.dart';
import 'package:english_mvvm_provider_clean/presentation/social_screen/widgets/individual_social_widget.dart';
import 'package:flutter/material.dart';

class PodiumListWidget extends StatelessWidget {
  final UsersViewmodel socialProvider;
  const PodiumListWidget({super.key, required this.socialProvider});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IndividualSocialWidget(
            screenHeight: screenHeight,
            id: 1,
            socialViewmodel: socialProvider,
          ),
          IndividualSocialWidget(
            screenHeight: screenHeight,
            id: 0,
            socialViewmodel: socialProvider,
          ),
          IndividualSocialWidget(
            screenHeight: screenHeight,
            id: 2,
            socialViewmodel: socialProvider,
          ),
        ],
      ),
    );
  }
}
