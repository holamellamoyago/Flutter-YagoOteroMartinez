import 'package:english_mvvm_provider_clean/config/app_colors.dart';
import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ButtonsLoginWidget extends StatelessWidget {
  const ButtonsLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double pageHeight = MediaQuery.of(context).size.height;
    AuthViewmodel authProvider = Provider.of<AuthViewmodel>(context);
    return Column(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            authProvider.carouselController.nextPage();
          },
          child: _signupEmailWidget(pageHeight),
        ),
        _signupGoogleWidget(pageHeight),
        _signupAsGuestWidget(pageHeight),
      ],
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


class TextFieldsEmailPassword extends StatelessWidget {
  const TextFieldsEmailPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          decoration: InputDecoration(hint: Text("Rellena el mail")),
          validator: ValidationBuilder().email(AppStrings.errorEmail).build(),
        )
        
      ],
    );
  }
}
