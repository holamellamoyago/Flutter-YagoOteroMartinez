import 'package:cuentalo/presentation/screens.dart';

class AppBarCustom extends StatelessWidget {
  const AppBarCustom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        child: AppBar(
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
                      PaddingCustom(width: 0.5.w,),
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
                      PaddingCustom(width: 0.5.w,),
                      Icon(Icons.logout_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
