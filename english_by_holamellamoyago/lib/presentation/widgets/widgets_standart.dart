
import 'package:english_by_holamellamoyago/presentation/screens.dart';


const mobileMaxWidth = 700;
const webMaxWidth = 1200;


class TitleLargeCustom extends StatelessWidget {
  const TitleLargeCustom({super.key, required this.titulo, this.align});

  final String titulo;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Text(
        titulo,
        style: GoogleFonts.josefinSans(
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
  const BodyCustom({super.key, required this.titulo, this.align, this.weight, this.color});

  final String titulo;
  final TextAlign? align;
  final FontWeight? weight;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Text(
        titulo,
        style: TextStyle(
          fontWeight: weight,
          color: color,
          fontSize: calcularTamanhoLetra(TipoFuente.body, constraints),
        ),
        textAlign: align,
      ),
    );
  }
}


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
    this.width = 0, this.child,
  });

  final Widget? child; 

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: child,
    );
  }
}


class ResponsiveWidget extends StatelessWidget {
  /// default constructor
  const ResponsiveWidget({
    super.key,
    this.mobile,
    this.tablet,
    this.web,
  });

  final Widget? mobile;
  final Widget? tablet;
  final Widget? web;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        if (maxWidth < mobileMaxWidth) {
          return mobile ?? const SizedBox();
        } else if (maxWidth < webMaxWidth) {
          return tablet ?? const SizedBox();
        }

        return web ?? const SizedBox();
      },
    );
  }
}


// class TextFieldCustom extends StatelessWidget {
//   const TextFieldCustom(
//       {super.key,
//       required this.label,
//       required this.controller,
//       this.fontSize});

//   final String label;
//   final TextEditingController controller;
//   final double? fontSize;

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       style: TextStyle(fontSize: fontSize ?? 4.sp),
//       controller: controller,
//       decoration: InputDecoration(
//           border: const OutlineInputBorder(),
//           label: Text(
//             label,
//             style: TextStyle(fontSize: fontSize ?? 4.sp),
//           )),
//     );
//   }
// }

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: 4.sp),
        
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}