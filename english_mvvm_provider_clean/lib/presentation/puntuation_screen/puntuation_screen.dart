import 'package:animate_do/animate_do.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:english_mvvm_provider_clean/config/app_colors.dart';
import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/auth_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/ia_viewmodel.dart';
import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
import 'package:english_mvvm_provider_clean/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
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
        children: [
          //TODO Aquí tiene que ir una cabecera
          SizedBox(),
          Expanded(
            child: viewmodel.messages.isEmpty
                ? BodyWithoutMessages()
                : BodyWithMessages(iaViewmodel: viewmodel),
          ),
          Footer(viewmodel: viewmodel),
        ],
      ),
    );
  }
}

class BodyWithMessages extends StatelessWidget {
  final IAViewmodel iaViewmodel;
  const BodyWithMessages({super.key, required this.iaViewmodel});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var authProvider = Provider.of<AuthViewmodel>(context, listen: false);

    var user =
        authProvider.currentUser ??
        AppUser(uid: "no-uid", name: "Debug", photoURL: "", username: "debug");

    return Column(
      children: [
        Expanded(
          child: FadeIn(
            duration: Durations.extralong4,
            child: ListView.builder(
              itemCount: iaViewmodel.messages.length,
              itemBuilder: (context, index) {
                var message = iaViewmodel.messages[index];
                bool isUser = message.role == OpenAIChatMessageRole.user;
                List<String> mensajes = [];
                int contentLength = message.content?.length ?? 0;

                for (var i = 0; i < contentLength; i++) {
                  String text = message.content?[i].text ?? '';
                  if (text.isNotEmpty) mensajes.add(text);
                }

                return MensajeIA(
                  isUser: isUser,
                  user: user,
                  authProvider: authProvider,
                  textTheme: textTheme,
                  mensajes: mensajes,
                );
              },
            ),
          ),
        ),
        iaViewmodel.isLoading()
            ? SizedBox(
                height: 10.h,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Tu mensaje esta cargando",
                        style: textTheme.bodySmall,
                      ),
                      SizedBox(width: 4.w),
                      CircularProgressIndicator(strokeWidth: 2),
                    ],
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}

class MensajeIA extends StatelessWidget {
  const MensajeIA({
    super.key,
    required this.isUser,
    required this.user,
    required this.authProvider,
    required this.textTheme,
    required this.mensajes,
  });

  final bool isUser;
  final AppUser user;
  final AuthViewmodel authProvider;
  final TextTheme textTheme;
  final List<String> mensajes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(100),
                child: isUser && user.image != null
                    ? Image.network(
                        authProvider.currentUser!.image!,
                        height: 4.h,
                      )
                    : Image.asset(AppStrings.logoImage, height: 4.h),
              ),

              SizedBox(width: 1.w),
              Text(
                isUser ? user.username : '¡Dino profe!',
                style: textTheme.bodySmall,
              ),
            ],
          ),
          SizedBox(height: 1.h),
          ...mensajes.map(
            (e) => FadeInRight(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryAccentColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GptMarkdown(e, style: textTheme.bodySmall, ),
                ),
              ),
            ),
          ),
        ],
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
          FadeInLeft(
            duration: Durations.extralong4,
            child: CuadroPosibilidadesIA(
              colorFondo: Colors.orangeAccent[100]!,
              colorIcono: Colors.orange,
              titulo: "Repasar Pharsal Verbs",
              subtitulo: "Practica los más comunes",
              prompt: "",
              icono: Icons.book,
            ),
          ),
          FadeInRight(
            duration: Durations.extralong4,
            child: CuadroPosibilidadesIA(
              colorFondo: Colors.lightBlueAccent[100]!,
              colorIcono: Colors.blue,
              titulo: "Dudas sobre verbos irregulares",
              subtitulo: "Tablas y ejemplos rápidos",
              prompt: "",
              icono: Icons.question_answer,
            ),
          ),
          FadeInUp(
            duration: Durations.extralong4,
            child: CuadroPosibilidadesIA(
              colorFondo: Colors.greenAccent[100]!,
              colorIcono: Colors.green,
              titulo: "Analiza una foto de mis deberes",
              subtitulo: "Sube una foto y la corregimos",
              prompt: "",
              icono: Icons.camera,
            ),
          ),
        ],
      ),
    );
  }
}

class CuadroPosibilidadesIA extends StatelessWidget {
  final Color colorFondo, colorIcono;
  final String titulo, subtitulo, prompt;
  final IconData icono;

  const CuadroPosibilidadesIA({
    super.key,
    required this.colorFondo,
    required this.titulo,
    required this.subtitulo,
    required this.prompt,
    required this.icono,
    required this.colorIcono,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Card(
        borderOnForeground: true,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
          side: BorderSide(color: AppColors.primaryAccentColor),
        ),
        child: ListTile(
          trailing: Icon(Icons.arrow_right),
          visualDensity: VisualDensity.comfortable,
          title: Text(titulo),
          subtitle: Text(subtitulo, style: textTheme.labelSmall),
          leading: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: colorFondo,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(icono, color: colorIcono),
            ),
          ),
        ),
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key, required this.viewmodel});

  final IAViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    TextEditingController txtFieldController = TextEditingController();

    void enviarMensajes() {
      String? mensaje = txtFieldController.text;

      if (mensaje.isEmpty) {
        showSnackBar(context, "Primero escribe un mensaje");
        return;
      }

      OpenAIChatCompletionChoiceMessageContentItemModel content =
          OpenAIChatCompletionChoiceMessageContentItemModel.text(mensaje);
      viewmodel.anadirContenido(content);

      viewmodel.mandarMensaje();

      txtFieldController.clear();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
              controller: txtFieldController,
              maxLines: null,
              minLines: 1,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: "Escribe tu duda aquí",
                filled: true,
                fillColor: AppColors.primaryAccentColor,
              ),
            ),
          ),
          SizedBox(width: 8),
          FilledButton.icon(
            onPressed: () => enviarMensajes(),
            label: Icon(Icons.send),
            style: ButtonStyle(),
          ),
        ],
      ),
    );
  }
}
