import 'package:dart_openai/dart_openai.dart';
import 'package:deepsheck/config/dotenv/app_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sizer/sizer.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  OpenAI.baseUrl = "https://api.deepseek.com";
  OpenAI.apiKey = AppDotenv.openAIKey;
  OpenAI.requestsTimeOut = Duration(minutes: 1);
  

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: Scaffold(
            appBar: AppBar(
              title: Text(
                'DeepSeek Chat',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              elevation: 2,
            ),
            body: HomePage(),
          ),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController txtController = TextEditingController();
  List<Map<String, dynamic>> mensajes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.grey.shade50, Colors.grey.shade100],
              ),
            ),
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: mensajes.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == mensajes.length && isLoading) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(AppDotenv.openAIKey),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Mensaje(
                  mensaje: mensajes[index]['mensaje'],
                  emisor: mensajes[index]['emisor'],
                );
              },
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: txtController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  radius: 24,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: isLoading ? null : empezarConversacion,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void empezarConversacion() async {
    String prompt = txtController.text.trim();

    if (prompt.isEmpty || isLoading) {
      return;
    }

    // Agregar mensaje del usuario
    setState(() {
      mensajes.add({'mensaje': prompt, 'emisor': true});
      isLoading = true;
    });

    txtController.clear();

    try {
      // Crear el chat completion con DeepSeek
      final chatCompletion = await OpenAI.instance.chat.create(
        model: "deepseek-chat",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt),
            ],
          ),
        ],
      );

      // Obtener la respuesta
      String respuesta =
          chatCompletion.choices.first.message.content?.first.text ??
          "Sin respuesta";

      setState(() {
        mensajes.add({'mensaje': respuesta, 'emisor': false});
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        mensajes.add({'mensaje': 'Error: ${e.toString()}', 'emisor': false});
        isLoading = false;
      });
    }
  }
}

class Mensaje extends StatelessWidget {
  final String mensaje;
  final bool emisor;

  const Mensaje({super.key, required this.mensaje, required this.emisor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: emisor
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 70.w),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: emisor ? Colors.deepPurple : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: emisor ? Radius.circular(20) : Radius.circular(4),
                bottomRight: emisor ? Radius.circular(4) : Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              mensaje,
              style: TextStyle(
                color: emisor ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
