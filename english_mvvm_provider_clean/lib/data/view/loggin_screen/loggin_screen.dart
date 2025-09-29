import 'package:english_mvvm_provider_clean/config/app_colors.dart';
import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:flutter/material.dart';

class LogginScreen extends StatelessWidget {
  const LogginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double pageHeight = MediaQuery.of(context).size.height;

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
                      "assets/images/logo.png",
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
                SizedBox(height: 8),
                _signupEmailWidget(pageHeight),
                _signupGoogleWidget(pageHeight),
                _signupAsGuestWidget(pageHeight),
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

  _signupEmailWidget(double pageHeight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: pageHeight * 0.05,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.email_outlined, color: Colors.white),
            Text(
              AppStrings.signupEmail,
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  _signupGoogleWidget(double pageHeight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: pageHeight * 0.05,
        decoration: BoxDecoration(
          color: AppColors.primaryAccentColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/images/logo_google.png"),
            ),
            Text(
              AppStrings.signupGoogle,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _signupAsGuestWidget(double pageHeight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline),
          Text(
            AppStrings.signupAsGuest,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
