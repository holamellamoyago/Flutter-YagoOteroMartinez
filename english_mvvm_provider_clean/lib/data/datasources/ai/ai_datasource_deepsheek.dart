import 'package:dart_openai/dart_openai.dart';
import 'package:english_mvvm_provider_clean/data/datasources/ai/ai_datasource.dart';

class AiDatasourceDeepsheek extends AIDatasource {
  @override
  Future<Stream<OpenAIStreamChatCompletionModel>> iniciarChat(
    List<OpenAIChatCompletionChoiceMessageModel> messages,
  ) async {
    Stream<OpenAIStreamChatCompletionModel> stream = OpenAI.instance.chat
        .createStream(model: "deepseek-chat", messages: messages);
    return stream;

    //OpenAIChatCompletionChoiceMessageModel(role: , content: content)
  }

  @override
  Future<void> mandarMensaje() {
    // TODO: implement mandarMensaje
    throw UnimplementedError();
  }
}
