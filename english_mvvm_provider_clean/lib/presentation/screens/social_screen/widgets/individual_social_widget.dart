import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/users_viewmodel.dart';
import 'package:flutter/material.dart';

class IndividualSocialWidget extends StatelessWidget {
  final double screenHeight;
  final int id;
  final UsersViewmodel socialViewmodel;

  const IndividualSocialWidget({
    super.key,
    required this.screenHeight,
    required this.id,
    required this.socialViewmodel,
  });

  @override
  Widget build(BuildContext context) {
    Color widgetColor;
    double imageHeight = screenHeight * 0.07;
    double sizeboxHeight = screenHeight * 0.1;

    switch (id) {
      case 0:
        widgetColor = Colors.amber;
        imageHeight = screenHeight * 0.1;
        sizeboxHeight = screenHeight * 0.15;
        break;
      case 1:
        widgetColor = Colors.grey;
      default:
        widgetColor = Colors.brown;
    }

    return SizedBox(
      height: sizeboxHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentGeometry.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              shape: BoxShape.circle,
              border: BoxBorder.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 20,
                  // spreadRadius: 4,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipOval(
                child: Image.asset(AppStrings.logoImage, height: imageHeight),
              ),
            ),
          ),
          Positioned(
            bottom: -10, // Ajusta para que sobresalga del borde
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: widgetColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.emoji_events, color: Colors.white, size: 18),
                  SizedBox(width: 4),
                  Text(
                    "${id + 1}º${socialViewmodel.users[id].username}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
