// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cuentalo/presentation/screens.dart';

class GroupScreen extends StatelessWidget {
  static const routename = '/grupo';
  const GroupScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController messageController = TextEditingController();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 11.h),
        child: const AppBarCustom(),
      ),
      body: Column(
        children: [
          const ListaMensajes(),
          envioMensaje(context, nameController, messageController),
          PaddingCustom(
            height: 1.h,
          )
        ],
      ),
    );
  }

  envioMensaje(context, nameController, messageController) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Column(
        children: [
          Row(
            children: [
              ButtonMessage(
                funcion: ()=>  Messages.sendPapel(context),
                urlImagen: 'assets/papel.png',
              ),
              ButtonMessage(
                funcion: () {},
                urlImagen: 'assets/preservativo.png',
              ),
              ButtonMessage(
                funcion: () {},
                urlImagen: 'assets/cerveza.png',
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[400],
                        border: Border.all(),
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(100),
                            topLeft: Radius.circular(100))),
                    child: Row(
                      children: [
                        PaddingCustom(
                          width: 2.w,
                        ),
                        Expanded(
                            child: TextField(
                          controller: messageController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              label: Text('Introduce tu mensaje')),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: () async {
                  await Messages.sendMessage(context, messageController);
                  messageController.text = '';
                },
                label: const Icon(Icons.send),
                style: ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(Size(8.w, 8.h)),
                    iconColor: WidgetStatePropertyAll(Colors.grey[200]),
                    backgroundColor: WidgetStatePropertyAll(
                      Colors.grey[700],
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ButtonMessage extends StatelessWidget {
  const ButtonMessage({
    super.key,
    required this.funcion,
    required this.urlImagen,
  });

  final VoidCallback funcion;
  final String urlImagen;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: funcion,
        child: Image.asset(
          urlImagen,
          height: 6.h,
        ));
  }
}

class ListaMensajes extends StatefulWidget {
  const ListaMensajes({super.key});

  @override
  State<ListaMensajes> createState() => _ListaMensajesState();
}

class _ListaMensajesState extends State<ListaMensajes> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser!;
    var prefs = PreferenciasUsuario();

    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Cuentalo')
            .doc('Groups')
            .collection(prefs.nombreGrupo)
            .orderBy('id') // Ordenar por el campo "id"
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            prefs.id = 1;
            return const Center(child: Text('No hay datos disponibles'));
          }

          final documents = snapshot.data!.docs;

          // Desplazar automáticamente al final cuando hay nuevos datos
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _scrollToBottom());

          return GestureDetector(
            onVerticalDragUpdate: (details) {
              // Mueve el scroll manualmente al detectar un gesto de arrastre
              _scrollController.jumpTo(
                _scrollController.offset - details.delta.dy,
              );
            },
            child: ListView.builder(
              controller: _scrollController, // Controla el desplazamiento
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final doc = documents[index];
                final mensaje = doc['Mensaje'] ?? 'Sin mensaje';
                final nombre = doc['Nombre'] ?? 'Sin nombre';
                prefs.id = documents.length + 1;
                print('Yago ' + prefs.id.toString());

                return auth.displayName == nombre
                    ? GloboEmisor(mensaje: mensaje)
                    : GloboRemitente(mensaje: mensaje);
              },
            ),
          );
        },
      ),
    );
  }
}

class GloboEmisor extends StatelessWidget {
  const GloboEmisor({
    super.key,
    required this.mensaje,
  });

  final String mensaje;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          child: ClipPath(
            clipper: UpperNipMessageClipperTwo(MessageType.send,
                nipWidth: 14, nipHeight: 10, nipRadius: -10),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: Container(
                  color: Colors.grey,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                    child: Text(
                      mensaje,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  )),
            ),
          ),
        ),
      ],
    );
  }
}

class GloboRemitente extends StatelessWidget {
  const GloboRemitente({
    super.key,
    required this.mensaje,
  });

  final String mensaje;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          child: ClipPath(
            clipper: UpperNipMessageClipperTwo(MessageType.receive,
                nipWidth: 14, nipHeight: 10, nipRadius: -10),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: Container(
                  color: Colors.grey,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                    child: Text(
                      mensaje,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
