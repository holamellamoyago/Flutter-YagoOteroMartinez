import 'package:flutter_ia/data/entities/entities.dart';
import 'package:flutter_ia/data/entities/part.dart';
import 'package:flutter_ia/domain/repositories/ia_repository.dart';
import 'package:get/get.dart';

class IAController extends GetxController {
  // final RxList<>
  RxBool isLoading = false.obs;
  RxString error = "".obs;

  final IARepository repository;
  final Contents contents = Contents(contents: []);

  IAController({required this.repository});

  void sendMessage() {
    contents.contents.add(
      Content(
        parts: [
          Part(
            text:
                'Eres un agente de IA entrenado y especializado en ser buena persona, tus objetivos son hacer un mensaje formar a partyir de los siguientes contenidos: ',
          ),
          Part(text: 'Jefe mandame de una maldita vez la aprobacion')
        ],
      ),
    );

    repository.sendMessage(contents);
  }
}
