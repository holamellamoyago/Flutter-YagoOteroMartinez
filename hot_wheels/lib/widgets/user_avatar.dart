import 'package:flutter/material.dart';
import '../theme/hw_theme.dart';

/// Reusable avatar for user profiles. Shows image if URL is valid,
/// falls back to a person icon or initial letter.
class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? displayName;
  final double radius;
  final bool showInitial; // show first letter instead of person icon

  const UserAvatar({
    super.key,
    this.imageUrl,
    this.displayName,
    this.radius = 20,
    this.showInitial = false,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: HwTheme.orange.withAlpha(30),
      foregroundImage: (imageUrl != null && imageUrl!.isNotEmpty)
          ? NetworkImage(imageUrl!)
          : null,
      child: showInitial && displayName != null && displayName!.isNotEmpty
          ? Text(
              displayName![0].toUpperCase(),
              style: TextStyle(
                fontSize: radius * 0.8,
                fontWeight: FontWeight.bold,
                color: HwTheme.orange,
              ),
            )
          : Icon(Icons.person, size: radius * 0.9),
    );
  }
}
