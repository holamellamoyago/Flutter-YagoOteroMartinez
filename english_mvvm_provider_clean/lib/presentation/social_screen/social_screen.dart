import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/database_viewmodel.dart';
import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DatabaseViewmodel socialProvider = Provider.of<DatabaseViewmodel>(
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
            GeneralTable(socialViewmodel: socialProvider),
          ],
        ),
      ),
    );
  }
}

class GeneralTable extends StatelessWidget {
  final DatabaseViewmodel socialViewmodel;
  const GeneralTable({super.key, required this.socialViewmodel});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    List<AppUser> users = socialViewmodel.users;
    return Expanded(
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => Card(
          elevation: 4,
          color: Colors.white,
          margin: EdgeInsets.all(8),
          child: ListTile(
            leading: SizedBox(
              width: screenWidth * 0.25,
              child: Row(
                children: [
                  Text("${index + 1}º", style: TextStyle(fontSize: 16)),
                  ClipOval(
                    child: Image.asset(
                      AppStrings.logoImage,
                      width: screenWidth * 0.2,
                    ),
                  ),
                ],
              ),
            ),
            title: Text(users[index].name),
            subtitle: Text(users[index].totalPoints.toString()),
            trailing: Icon(Icons.person_add_alt_1_outlined),
          ),
        ),
      ),
    );
  }
}

class PodiumListWidget extends StatelessWidget {
  final DatabaseViewmodel socialProvider;
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
            id: 2,
            socialViewmodel: socialProvider,
          ),
          IndividualSocialWidget(
            screenHeight: screenHeight,
            id: 1,
            socialViewmodel: socialProvider,
          ),
          IndividualSocialWidget(
            screenHeight: screenHeight,
            id: 3,
            socialViewmodel: socialProvider,
          ),
        ],
      ),
    );
  }
}

class IndividualSocialWidget extends StatelessWidget {
  final double screenHeight;
  final int id;
  final DatabaseViewmodel socialViewmodel;

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
      case 1:
        widgetColor = Colors.amber;
        imageHeight = screenHeight * 0.1;
        sizeboxHeight = screenHeight * 0.15;
        break;
      case 2:
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
                child: Image.asset(
                  "assets/images/logo.png",
                  height: imageHeight,
                ),
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
                    "$idº ${socialViewmodel.users[id].name}",
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
