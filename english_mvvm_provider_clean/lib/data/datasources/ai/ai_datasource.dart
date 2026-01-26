import 'package:dart_openai/dart_openai.dart';

abstract class AIDatasource {
  Future<Stream<OpenAIStreamChatCompletionModel>> iniciarChat(
    List<OpenAIChatCompletionChoiceMessageModel> messages,
  );
  
  Future<OpenAIChatCompletionChoiceMessageModel> mandarMensaje(
    List<OpenAIChatCompletionChoiceMessageModel> messages,
  );
}
