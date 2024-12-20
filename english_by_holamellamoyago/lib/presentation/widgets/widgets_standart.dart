import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class TitleLargeCustom extends StatelessWidget {
  const TitleLargeCustom({super.key, required this.titulo, required this.sp, this.align});

  final String titulo;
  final double sp;
    final TextAlign? align;


  @override
  Widget build(BuildContext context) {
    return Text(
      titulo,
      style: GoogleFonts.silkscreen(fontSize: sp.sp),
      textAlign: align,
    );
  }
}

class TitleMediumCustom extends StatelessWidget {
  const TitleMediumCustom({
    super.key,
    required this.titulo,
    this.align,
    required this.sp,
  });

  final String titulo;
  final TextAlign? align;
  final double sp;

  @override
  Widget build(BuildContext context) {
    return Text(
      titulo,
      style: GoogleFonts.lato(fontSize: sp.sp,fontWeight: FontWeight.bold),
      textAlign: align,
    );
  }
}

class TitleSmallcustom extends StatelessWidget {
  const TitleSmallcustom({super.key, required this.titulo, required this.sp});

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



class BodyCustom extends StatelessWidget {
  const BodyCustom( {super.key, required this.titulo, this.align, required this.sp});

  final String titulo;
  final TextAlign? align;
  final double sp;

  @override
  Widget build(BuildContext context) {
    return Text(
      titulo,
      style: TextStyle(fontSize: sp.sp, ),
      textAlign: align,
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