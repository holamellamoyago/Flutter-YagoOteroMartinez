import 'package:english_mvvm_provider_clean/config/app_colors.dart';
import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/data/view/loggin_screen/auth_button_widget.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ButtonsLoginWidget extends StatelessWidget {
  const ButtonsLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [_authButtons(), _singnUpWidget()],
    );
  }

  Widget _authButtons() {
    return Column(
      spacing: 16,
      children: [
        AuthButton(
          customIcon: Icon(Icons.email_outlined),
          customText: AppStrings.signupEmail,
          containerColor: AppColors.primaryColor,
          textColor: Colors.white,
        ),
        AuthButton(
          customIcon: Image.asset(AppStrings.googleIcon),
          customText: AppStrings.signupGoogle,
          containerColor: AppColors.primaryAccentColor,
          textColor: Colors.black,
        ),
        AuthButton(
          customIcon: Icon(Icons.person_outline),
          customText: AppStrings.signupAsGuest,
          containerColor: Colors.transparent,
          textColor: Colors.black,
        ),
      ],
    );
  }

  _singnUpWidget() {
    return Row(
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
    );
  }
}



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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 16,
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

  void checkValidation(AuthViewmodel authProvider) {
    String email = _emailControlleer.text;
    String password = _passwordController.text;
    String confirPassword = _confirmPasswordController.text;

    if (_formKey.currentState!.validate() && password == confirPassword) {
      authProvider.createAccountEmailPassword(email, password);
      context.go(AppStrings.mainHomeScreen);
    } else {}
  }
}

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

// En un archivo utils o en el widget
void showSnackBar(BuildContext context, String message, {Color? color}) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
}
