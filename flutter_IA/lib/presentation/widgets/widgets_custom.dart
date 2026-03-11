import 'package:flutter/material.dart';
import 'package:plantilla_flutter/presentation/screens.dart';


class PaddingCustom extends StatelessWidget {
  final double height;
  final double width;
  const PaddingCustom({
    super.key,
    this.height = 0,
    this.width = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}

class ImagenCustom extends StatelessWidget {
  final String image;
  final double scale;
  const ImagenCustom({super.key, required this.image, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      scale: scale,
    );
  }
}

class TitleMediumCustom extends StatelessWidget {
  const TitleMediumCustom({
    super.key,
    required this.titulo,
  });

  final String titulo;

  @override
  Widget build(BuildContext context) {
    final titleStyleMedium = Theme.of(context).textTheme.titleMedium;
    return Text(
      titulo,
      style: titleStyleMedium,
    );
  }
}

class TitleSmallcustom extends StatelessWidget {
  const TitleSmallcustom({super.key, required this.titulo});

  final String titulo;

  @override
  Widget build(BuildContext context) {
    final titleStyleSmall = Theme.of(context).textTheme.titleSmall;
    return Text(
      titulo,
      style: titleStyleSmall,
    );
  }
}

class BodyMediumCustom extends StatelessWidget {
  const BodyMediumCustom({super.key, required this.titulo});

  final String titulo;

  @override
  Widget build(BuildContext context) {
    final subtitleStyleMedium = Theme.of(context).textTheme.bodyMedium;
    return Text(
      titulo,
      style: subtitleStyleMedium,
    );
  }
}

class BodySmallCustom extends StatelessWidget {
  const BodySmallCustom({super.key, required this.titulo});

  final String titulo;

  @override
  Widget build(BuildContext context) {
    final bodyStyleSmall = Theme.of(context).textTheme.bodySmall;
    return Text(
      titulo,
      style: bodyStyleSmall,
    );
  }
}


class GestureDetectorCustom extends StatelessWidget {
  final String texto;
  final String navegacion;
  const GestureDetectorCustom({
    super.key,
    required this.texto,
    required this.navegacion,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(texto),
      onTap: () => context.push(navegacion),
    );
  }
}