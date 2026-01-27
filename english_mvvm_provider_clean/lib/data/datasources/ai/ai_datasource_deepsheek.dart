import 'package:dart_openai/dart_openai.dart';
import 'package:english_mvvm_provider_clean/data/datasources/ai/ai_datasource.dart';

class AiDatasourceDeepsheek extends AIDatasource {
  final OpenAI openAI = OpenAI.instance;
  final String model = "deepseek-chat";

  @override
  Future<Stream<OpenAIStreamChatCompletionModel>> iniciarChat(
    List<OpenAIChatCompletionChoiceMessageModel> messages,
  ) async {
    Stream<OpenAIStreamChatCompletionModel> stream = openAI.chat.createStream(
      model: model,
      messages: messages,
    );
    return stream;

    //OpenAIChatCompletionChoiceMessageModel(role: , content: content)
  }

  @override 
  Future<OpenAIChatCompletionChoiceMessageModel > mandarMensaje(
    List<OpenAIChatCompletionChoiceMessageModel> messages,
  ) async {
    OpenAIChatCompletionModel newChat = await openAI.chat.create(
      model: model,
      messages: messages,
      temperature: 0.1
    );

    OpenAIChatCompletionChoiceModel message = newChat.choices.last;
    return message.message;
  }
}
