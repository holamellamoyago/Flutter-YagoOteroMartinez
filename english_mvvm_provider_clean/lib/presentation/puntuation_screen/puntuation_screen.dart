import 'package:english_mvvm_provider_clean/config/app_colors.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/ia_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PuntuationScreen extends StatelessWidget {
  const PuntuationScreen({super.key});

  final String respuesta = "Cargando la respuesta...";

  @override
  Widget build(BuildContext context) {
    IAViewmodel viewmodel = Provider.of<IAViewmodel>(context, listen: true);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [SizedBox(), BodyWithoutMessages(), Footer()],
      ),
    );
  }
}

class BodyWithoutMessages extends StatelessWidget {
  const BodyWithoutMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage("assets/images/logo.png"),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            '¡Hola! Te invitamos a utilizar nuestro Dino-Profe',
            style: textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          Text(
            'Utilizamos la mejor tecnología para resolver todas tus dudas',
            style: textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}

class CuadroPosibilidadesIA extends StatelessWidget {
  final Color color;
  final String titulo, subtitulo, prompt;
  final Icon icono;

  const CuadroPosibilidadesIA({
    super.key,
    required this.color,
    required this.titulo,
    required this.subtitulo,
    required this.prompt,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(titulo),
      subtitle: Text(subtitulo),
      leading: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: color),
        child: icono,
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryAccentColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: IconButton(
              onPressed: () => null,
              icon: Icon(Icons.attach_file),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Escribe tu duda aquí",
                filled: true,
                fillColor: AppColors.primaryAccentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
