import 'package:dart_openai/dart_openai.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/ai_repositorie.dart';
import 'package:flutter/material.dart';

class IAViewmodel extends ChangeNotifier {
  final AIRepositorie repository;

  IAViewmodel({required this.repository});

  bool _isloading = false;
  String? error;
  List<OpenAIChatCompletionChoiceMessageModel> messages = [];

  Future<void> crearChat() async {
    repository.iniciarChat(messages);
  }

  Future<void> mandarMensaje(String mensaje) async {
    repository.mandarMensaje();
  }
}
