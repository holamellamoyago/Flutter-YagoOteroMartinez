import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const AnswerButton({
    super.key,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        height: screenHeight * 0.1,
        width: screenWidth * 0.4,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            _capitalizeText(text),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }

  String _capitalizeText(String txt) {
    String char = txt.substring(0, 1).toUpperCase();
    String txtCapitalize = txt.substring(1, txt.length);

    return char + txtCapitalize;
  }
}
