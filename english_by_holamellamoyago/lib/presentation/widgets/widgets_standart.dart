
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





class TextFieldCustom extends StatefulWidget {
  const TextFieldCustom({
    super.key,
    required this.controller,
    required this.label,
    this.fontsize,
  });

  final TextEditingController controller;
  final String label;
  final double? fontsize;

  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  

  bool ocultacion = true;
  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: '${widget.controller}',
      obscureText: widget.label == 'Email' ? false : ocultacion,
      controller: widget.controller,
      style: TextStyle(fontSize: widget.fontsize ?? 4.sp),
      decoration: InputDecoration(
        filled: true,
        suffixIcon: widget.label == 'password' || widget.label == 'confirm password' ? Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.w),
          child: AnimatedIconButton(
            onPressed: () {
              setState(() {
                ocultacion =! ocultacion;
              });
            },
            icons: [
            AnimatedIconItem(icon: Icon(Icons.visibility)),
            AnimatedIconItem(icon: Icon(Icons.visibility_off)),
          ])
        ) : SizedBox(),
        constraints: BoxConstraints(maxWidth: 40.w),
        border: const OutlineInputBorder(),
        label: Text(
          widget.label,
          style: TextStyle(fontSize: widget.fontsize ?? 4.sp),
        ),
      ),
    );
  }
}