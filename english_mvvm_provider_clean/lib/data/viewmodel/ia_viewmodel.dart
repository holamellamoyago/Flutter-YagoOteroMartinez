import 'package:dart_openai/dart_openai.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/ai_repositorie.dart';
import 'package:flutter/material.dart';

class IAViewmodel extends ChangeNotifier {
  final AIRepositorie repository;

  IAViewmodel({required this.repository});

  bool _loading = false;
  String? _error;
  ScrollController _listController = ScrollController();

  List<OpenAIChatCompletionChoiceMessageContentItemModel> contents = [];
  List<OpenAIChatCompletionChoiceMessageModel> messages = [];

  bool isLoading() => _loading;
  ScrollController listController() => _listController;

  /*
    OpenAIChatCompletionChoiceMessageModel -> Mensaje entero (rol + contenido)
    OpenAIChatCompletionChoiceMessageContentItemModel -> Contenido de cada Mensaje indivisual (Puede ser varios de cada) (texto , imagenes y más)
  */

  void anadirContenido(
    OpenAIChatCompletionChoiceMessageContentItemModel content,
  ) {
    contents.add(content);
  }

  Future<void> crearChat() async {
    repository.iniciarChat(messages);
  }

  Future<void> mandarMensaje() async {
    final List<OpenAIChatCompletionChoiceMessageContentItemModel> contentsCopy =
        List.from(contents); //TODO ¿Esto?

    OpenAIChatCompletionChoiceMessageModel message =
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user,
          content: contentsCopy,
        );

    messages.add(message); // La respuesta del usuario
    contents.clear();
    _loading = true;

    notifyListeners();

    final OpenAIChatCompletionChoiceMessageModel response = await repository
        .mandarMensaje(messages);
    messages.add(response); // Respuesta del servidor

    _loading = false;
    notifyListeners();

    _listController.animateTo(
      _listController.position.maxScrollExtent,
      duration: Durations.long1,
      curve: Curves.bounceIn,
    );

    notifyListeners();
  }
}
