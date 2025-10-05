import 'package:english_mvvm_provider_clean/config/app_colors.dart';
import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/data/view/loggin_screen/auth_button_widget.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/auth_viewmodel.dart';
import 'package:english_mvvm_provider_clean/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ButtonsLoginWidget extends StatelessWidget {
  const ButtonsLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    AuthViewmodel authProvider = Provider.of<AuthViewmodel>(
      context,
      listen: false,
    );
    return Column(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _authButtons(context, authProvider),
        _singnUpWidget(authProvider),
      ],
    );
  }

  Widget _authButtons(BuildContext context, AuthViewmodel authProvider) {
    return Column(
      spacing: 16,
      children: [
        AuthButton(
          customIcon: Icon(Icons.email_outlined),
          customText: AppStrings.signupEmail,
          containerColor: AppColors.primaryColor,
          textColor: Colors.white,
          customVoid: () {
            authProvider.carouselController.animateToPage(2);
          },
        ),
        AuthButton(
          customIcon: Image.asset(AppStrings.googleIcon),
          customText: AppStrings.signupGoogle,
          containerColor: AppColors.primaryAccentColor,
          textColor: Colors.black,
          customVoid: () async {
            try {
              await authProvider.loginGoogle();

              if (context.mounted) {
                context.go(AppStrings.mainHomeScreen);
              }
            } catch (e) {
              print(e.toString());
              showSnackBar(context, e.toString());
            }
          },
        ),
        AuthButton(
          customIcon: Icon(Icons.person_outline),
          customText: AppStrings.signupAsGuest,
          containerColor: Colors.transparent,
          textColor: Colors.black,
          customVoid: null,
        ),
      ],
    );
  }

  _singnUpWidget(AuthViewmodel authProvider) {
    return GestureDetector(
      onTap: () async {
        await authProvider.carouselController.animateToPage(1);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.signUpText1,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            AppStrings.signUpText2,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
