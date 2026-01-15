import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessages() {
    List<String> messages = [
      'Comprando palomitas',
      'Cocinando el final',
      'Esperando a la novia',
      'Esto esta tardando mas de lo esperado :()',
    ];

    return Stream.periodic(Duration(milliseconds: 1200), (computationCount) {
      return messages[computationCount];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(strokeWidth: 2),
          SizedBox(height: 10),
          StreamBuilder(
            stream: getLoadingMessages(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text("Cargando... ");
              }

              return Text(snapshot.data!);
            },
          ),
        ],
      ),
    );
  }
}
