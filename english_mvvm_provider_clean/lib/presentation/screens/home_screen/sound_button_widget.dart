import 'package:english_mvvm_provider_clean/presentation/providers/sound_provider.dart';
import 'package:flutter/material.dart';

class SoundButton extends StatefulWidget {
  const SoundButton({
    super.key,
    required this.soundProvider,
    required this.screenHeight,
  });

  final SoundProvider soundProvider;
  final double screenHeight;

  @override
  State<SoundButton> createState() => _SoundButtonState();
}

class _SoundButtonState extends State<SoundButton> {
  @override
  void initState() {
    widget.soundProvider.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.soundProvider.toggleBackgroundSound(),
      child: Icon(
        widget.soundProvider.backgroundIcon,
        size: widget.screenHeight * 0.05,
        color: Colors.white,
      ),
    );
  }
}