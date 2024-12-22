import 'dart:io';

import 'package:english_by_holamellamoyago/presentation/screens.dart';


class TitleLargeCustom extends StatelessWidget {
  const TitleLargeCustom({super.key, required this.titulo, this.align});

  final String titulo;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      //TODO Arreglar esto
      return Text(
        titulo,
        style: GoogleFonts.silkscreen(
            fontSize: calcularTamanhoLetra(TipoFuente.large, constraints)),
        textAlign: align,
      );
    });
  }
}

class TitleMediumCustom extends StatelessWidget {
  const TitleMediumCustom({
    super.key,
    required this.titulo,
    this.align,
  });

  final String titulo;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Text(
        titulo,
        style: GoogleFonts.lato(
            fontSize: calcularTamanhoLetra(TipoFuente.medium, constraints),
            fontWeight: FontWeight.bold),
        textAlign: align,
      ),
    );
  }
}

class TitleSmallcustom extends StatelessWidget {
  const TitleSmallcustom({super.key, required this.titulo});

  final String titulo;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Text(
        titulo,
        style: TextStyle(
            fontSize: calcularTamanhoLetra(TipoFuente.small, constraints)),
      ),
    );
  }
}

class BodyCustom extends StatelessWidget {
  const BodyCustom({super.key, required this.titulo, this.align});

  final String titulo;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Text(
        titulo,
        style: TextStyle(
          fontSize: calcularTamanhoLetra(TipoFuente.body, constraints),
        ),
        textAlign: align,
      ),
    );
  }
}

// class BodySmallCustom extends StatelessWidget {
//   const BodySmallCustom({super.key, required this.titulo, required this.sp});

//   final String titulo;
//   final double sp;

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       titulo,
//       style: TextStyle(fontSize: sp.sp),
//     );
//   }
// }

class LabelLarge extends StatelessWidget {
  const LabelLarge({super.key, required this.titulo, required this.sp});

  final String titulo;
  final double sp;

  @override
  Widget build(BuildContext context) {
    return Text(
      titulo,
      style: TextStyle(fontSize: sp.sp),
    );
  }
}

class LabelMedium extends StatelessWidget {
  const LabelMedium({super.key, required this.titulo, required this.sp});

  final String titulo;
  final double sp;

  @override
  Widget build(BuildContext context) {
    return Text(
      titulo,
      style: TextStyle(fontSize: sp.sp),
    );
  }
}

class LabelSmall extends StatelessWidget {
  const LabelSmall({super.key, required this.titulo, required this.sp});

  final String titulo;
  final double sp;

  @override
  Widget build(BuildContext context) {
    return Text(
      titulo,
      style: TextStyle(fontSize: sp.sp),
    );
  }
}

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


// class BodyMediumCustom extends StatelessWidget {
//   const BodyMediumCustom({super.key, required this.titulo, required this.sp});

//   final String titulo;
//   final double sp;

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       titulo,
//       style: TextStyle(fontSize: sp.sp),
//     );
//   }
// }