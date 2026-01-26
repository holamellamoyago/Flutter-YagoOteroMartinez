import 'package:dart_openai/dart_openai.dart';
import 'package:english_mvvm_provider_clean/data/datasources/ai/ai_datasource.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/ai_repositorie.dart';

class AIRepositorieImpl extends AIRepositorie {
  final AIDatasource datasource;

  AIRepositorieImpl({required this.datasource});

  @override
  Future<Stream<OpenAIStreamChatCompletionModel>> iniciarChat(
    List<OpenAIChatCompletionChoiceMessageModel> messages,
  ) {
    return datasource.iniciarChat(messages);
  }
  
  @override
  Future<OpenAIChatCompletionChoiceMessageModel> mandarMensaje(List<OpenAIChatCompletionChoiceMessageModel> messages) {
    return datasource.mandarMensaje(messages);
  }

}
