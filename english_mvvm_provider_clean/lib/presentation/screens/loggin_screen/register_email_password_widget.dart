import 'package:english_mvvm_provider_clean/data/viewmodel/auth_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/users_viewmodel.dart';
import 'package:english_mvvm_provider_clean/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterEmailPassword extends StatefulWidget {
  const RegisterEmailPassword({super.key});

  @override
  State<RegisterEmailPassword> createState() => _RegisterEmailPasswordState();
}

class _RegisterEmailPasswordState extends State<RegisterEmailPassword> {
  final TextEditingController _emailControlleer = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    _emailControlleer.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthViewmodel authProvider = Provider.of<AuthViewmodel>(
      context,
      listen: false,
    );

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailControlleer,
              decoration: authProvider.inputDecoration(AppStrings.signupEmail),
              validator: ValidationBuilder()
                  .email(AppStrings.errorEmail)
                  .build(),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: authProvider.inputDecoration(AppStrings.password),
              validator: ValidationBuilder()
                  .minLength(6, AppStrings.errorPasswordLenght)
                  .required()
                  .build(),
            ),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: authProvider.inputDecoration(
                AppStrings.confirmPassword,
              ),
              validator: ValidationBuilder()
                  .minLength(6, AppStrings.errorPasswordLenght)
                  .required()
                  .build(),
            ),
            Align(
              alignment: AlignmentGeometry.centerRight,
              child: FilledButton(
                onPressed: () => checkValidation(authProvider),
                // onPressed: () => checkValidation(authProvider),
                child: Text("Crear cuenta"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkValidation(AuthViewmodel authProvider) async {
    String email = _emailControlleer.text;
    String password = _passwordController.text;
    String confirPassword = _confirmPasswordController.text;

    UsersViewmodel usersProvider = Provider.of<UsersViewmodel>(
      context,
      listen: false,
    );

    setState(() {
      isLoading = true;
    });

    if (_formKey.currentState!.validate() && password == confirPassword) {
      try {
        await authProvider.createAccountEmailPassword(email, password);
        await usersProvider.manageUser(authProvider.getCurrentUser);

        if (mounted) {
          context.go(AppStrings.mainHomeScreen);
        }
      } catch (e) {
        if (mounted) {
          showSnackBar(context, e.toString());
        }
      }
    } else {
      setState(() {
        isLoading = false;
      });

      showSnackBar(context, "Problems checking the text fields");
    }
  }
}
