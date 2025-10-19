import 'package:carousel_slider/carousel_slider.dart';
import 'package:english_mvvm_provider_clean/config/app_colors.dart';
import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogginScreen extends StatelessWidget {
  const LogginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double pageHeight = MediaQuery.of(context).size.height;
    AuthViewmodel authProvider = Provider.of<AuthViewmodel>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.appTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Column(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryAccentColor,
                    ),
                    child: Image.asset(
                      AppStrings.logoImage,
                      height: pageHeight * 0.2,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  AppStrings.titleLoginScreen,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  AppStrings.subtitleLoginScreen,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                authProvider.isLoading
                    ? CircularProgressIndicator()
                    : SizedBox(
                        height: pageHeight * 0.33,
                        child: CarouselSlider(
                          carouselController: authProvider.carouselController,
                          disableGesture: false,
                          items: AuthViewmodel.carouselItems,
                          options: authProvider.carouselOptions(pageHeight),
                        ),
                      ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                AppStrings.therms,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
