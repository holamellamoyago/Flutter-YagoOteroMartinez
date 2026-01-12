import 'package:cached_network_image/cached_network_image.dart';
import 'package:english_mvvm_provider_clean/config/app_colors.dart';
import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    AuthViewmodel authProvider = Provider.of<AuthViewmodel>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: authProvider.getCurrentUser.image ?? "no-url",
                progressIndicatorBuilder: (context, url, progress) =>
                    CircularProgressIndicator(value: progress.progress),
                errorWidget: (context, url, error) =>
                    Image.asset("assets/images/logo.png", fit: BoxFit.cover),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        color: AppColors.primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.appTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 32),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () => context.push(AppStrings.levelsScreen),
                child: Container(
                  height: screenHeight * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(4, 4),
                        color: Colors.deepOrangeAccent,
                        blurRadius: 4,
                        blurStyle: BlurStyle.normal,
                      ),
                      BoxShadow(
                        offset: Offset(-4, -4),
                        color: Colors.deepOrangeAccent,
                        blurRadius: 8,
                        blurStyle: BlurStyle.normal,
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: [
                        Colors.orangeAccent,
                        Colors.orange,
                        Colors.deepOrangeAccent,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Play",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
