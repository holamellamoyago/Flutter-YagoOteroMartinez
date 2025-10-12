import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/auth_viewmodel.dart';
import 'package:english_mvvm_provider_clean/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:form_validator/form_validator.dart';

class SignInEmailPassword extends StatefulWidget {
  const SignInEmailPassword({super.key});

  @override
  State<SignInEmailPassword> createState() => _SignInEmailPasswordState();
}

class _SignInEmailPasswordState extends State<SignInEmailPassword> {
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
        key: _key,
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: authProvider.inputDecoration(AppStrings.signupEmail),
              validator: ValidationBuilder().email().build(),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: authProvider.inputDecoration(AppStrings.password),
              validator: ValidationBuilder().minLength(6).build(),
            ),
            Align(
              alignment: AlignmentGeometry.bottomRight,
              child: FilledButton(
                onPressed: () async {
                  _checkLogin(authProvider);
                },
                child: Text("Sign in"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkLogin(AuthViewmodel authProvider) async {
    try {
      setState(() {
        isLoading = true;
      });

      await authProvider.loginEmailPassword(
        _emailController.text,
        _passwordController.text,
      );
    } catch (e) {
      // Cierra el dialog en caso de error
      if (mounted) {
        showSnackBar(context, e.toString(), color: Colors.red);
      }

      setState(() {
        isLoading = false;
      });
    }
  }
}
