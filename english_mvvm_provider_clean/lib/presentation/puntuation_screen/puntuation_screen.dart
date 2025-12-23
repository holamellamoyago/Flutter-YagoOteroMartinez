import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';

class PuntuationScreen extends StatefulWidget {
  const PuntuationScreen({super.key});

  @override
  State<PuntuationScreen> createState() => _PuntuationScreenState();
}

class _PuntuationScreenState extends State<PuntuationScreen> {
  String respuesta = "Cargando la respuesta...";

  @override
  Widget build(BuildContext context) {
    _generarRespuesta();

    return Scaffold(
      body: Center(
        child: Text(respuesta, style: TextStyle(color: Colors.black)),
      ),
    );
  }

  _generarRespuesta() async {

    final GenerativeModel model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.5-flash',
    );

    final Iterable<Content> txt = [
      Content.text(
        "Genérame tres cualidades innovadoras que tenga que llevar una app para aprender inglés",
      ),
    ];

    final response = await model.generateContent(txt);

    print(response.text);

    // setState(() {
    //   respuesta = response.text ?? "No cargo la respuesta";
    // });
  }
}
