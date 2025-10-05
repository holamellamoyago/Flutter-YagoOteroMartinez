import 'package:flutter/material.dart';
class AuthButton extends StatelessWidget {
  final Widget customIcon;
  final String customText;
  final Color containerColor;
  final Color textColor;

  const AuthButton({
    super.key,
    required this.customIcon,
    required this.customText,
    required this.containerColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    double pageHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: pageHeight * 0.05,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: const EdgeInsets.all(8.0), child: customIcon),
            Text(
              customText,
              style: TextStyle(color: textColor, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}