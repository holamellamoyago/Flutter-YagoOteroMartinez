import 'package:flutter/material.dart';
import 'package:plantilla_flutter/configure/preferences/app_preferences.dart';
import 'package:plantilla_flutter/presentation/Mobile/mobile_home_screen.dart';

const mobileMaxWidth = 700;
const webMaxWidth = 1200;
const colorPrimario = Color.fromARGB(196, 218, 250, 255);
const colorSecundario = Color.fromARGB(98, 0, 137, 241);

class HomeScreen extends StatelessWidget {
  static const routeName = '/';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var prefs = PreferenciasUsuario();
    prefs.uuid = prefs.generarUuid;
    return const ResponsiveWidget(
      mobile: MobileScreen(),
      tablet: null,
      web: null,
    );
  }
}

class ResponsiveWidget extends StatelessWidget {
  /// default constructor
  const ResponsiveWidget({
    Key? key,
    this.mobile,
    this.tablet,
    this.web,
  }) : super(key: key);

  final Widget? mobile;
  final Widget? tablet;
  final Widget? web;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final _maxWidth = constraints.maxWidth;

        if (_maxWidth < mobileMaxWidth) {
          return mobile ?? const SizedBox();
        } else if (_maxWidth < webMaxWidth) {
          return tablet ?? const SizedBox();
        }

        return web ?? const SizedBox();
      },
    );
  }
}

