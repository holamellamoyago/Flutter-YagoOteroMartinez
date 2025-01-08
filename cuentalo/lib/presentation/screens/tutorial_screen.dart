import 'package:animated_gradient/animated_gradient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuentalo/config/preferences/pref_usuarios.dart';
import 'package:cuentalo/presentation/screens/home_screen.dart';
import 'package:cuentalo/presentation/widgets/widgets_standart.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class TutorialScreen extends StatelessWidget {
  static const routename = '/tutorial';
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradient(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [BodyCustom(titulo: 'Aquí inicia')],
          ),
        ),
      ),
    );
  }
}
