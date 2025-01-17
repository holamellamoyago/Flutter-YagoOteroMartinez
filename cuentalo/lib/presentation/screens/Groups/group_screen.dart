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
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(tabs: [
              Tab(
                  icon: Icon(Icons.chat),
                  child: Text(
                    'Ganadores',
                    style: TextStyle(fontSize: 16.sp),
                  )),
              Tab(
                  icon: Icon(Icons.emoji_events_outlined),
                  child: Text(
                    'Posiciones',
                    style: TextStyle(fontSize: 16.sp),
                  ))
            ]),
            centerTitle: true,
            title: const TitleLargeCustom(titulo: 'Cuéntalo'),
            actions: [
              PopupMenuButton(
                icon: Icon(Icons.person_2_outlined),
                itemBuilder: (context) => <PopupMenuEntry<ListTile>>[
                  PopupMenuItem<ListTile>(
                    onTap: () {
                      context.push('/settings');
                    },
                    value: ListTile(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Ajustes'),
                        PaddingCustom(
                          width: 0.5.w,
                        ),
                        Icon(Icons.settings),
                      ],
                    ),
                  ),
                  PopupMenuItem<ListTile>(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      context.go('/login');
                    },
                    value: ListTile(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Cerrar sesión'),
                        PaddingCustom(
                          width: 0.5.w,
                        ),
                        Icon(Icons.logout_outlined),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: TabBarView(children: [
            ganadores(context, nameController, messageController),
            posiciones()
          ])),
    );
  }

  Widget ganadores(context, nameController, messageController) {
    return Column(
      children: [
        const ListaMensajes(),
        envioMensaje(context, nameController, messageController),
        PaddingCustom(
          height: 1.h,
        )
      ],
    );
  }

  Widget posiciones() {
    return Column(
      children: [
        categorias(),
      ],
    );
  }

  Widget categorias() {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                    height: 6.h,
                    width: 6.h,
                    color: Colors.grey[300],
                    child: Icon(Icons.code)),
              ),
              PaddingCustom(
                width: 2.w,
              ),
              Text(
                "Top Cerveceros",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              )
            ],
          ),
          PaddingCustom(height: 1.h,),
          const BodyCustom(
            titulo: "Comúnmente conocidos por su barriga cervecera",
            align: TextAlign.start,
          ),
          PaddingCustom(height: 4.h,),
          Row(
            children: [
              Icon(Icons.workspace_premium_outlined, size: 4.5.h,color: Colors.amber[500],), 
              PaddingCustom(width: 2.w,),
              Container(
                height: 8.h,
                width: 8.h,
                // color: Colors.red,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.amber[600]!, width: 4)
                ),
              ), 
              PaddingCustom(width: 4.w,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('John Smith',style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),),
                  Text("143 contribuciones", style:  TextStyle(fontSize: 10.sp),)
                ],
              ),
            ],
          ),
          PaddingCustom(height: 4.h,),
              Container(height: 1, color: Colors.grey, width: double.infinity,)
        ],
      ),
    );
  }

  envioMensaje(BuildContext context, nameController, messageController) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Column(
        children: [
          Row(
            children: [
              ButtonMessage(
                funcion: () {
                    Messages.sendPapel(context );
                },
                urlImagen: 'assets/papel.png',
              ),
              PaddingCustom(
                width: 4.w,
              ),
              ButtonMessage(
                funcion: () {},
                urlImagen: 'assets/preservativo.png',
              ),
              PaddingCustom(
                width: 4.w,
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            urlImagen,
            height: 4.h,
          ),
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
