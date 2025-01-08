

import 'package:cuentalo/presentation/screens/login_screen.dart';
import 'package:cuentalo/presentation/screens/group_screen.dart';
import 'package:cuentalo/presentation/screens/home_screen.dart';
import 'package:cuentalo/presentation/screens/join2_group.dart.dart';
import 'package:cuentalo/presentation/screens/join_group_screen.dart';
import 'package:cuentalo/presentation/screens/new_group_screen.dart';
import 'package:cuentalo/presentation/screens/tutorial_screen.dart';
import 'package:go_router/go_router.dart';


final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/login',
    name: LoginPage.name,
    builder: (context, state) => const LoginPage(),
  ),
  GoRoute(
    path: '/tutorial',
    name: TutorialScreen.routename,
    builder: (context, state) => const TutorialScreen(),
  ),
  GoRoute(
    path: '/',
    name: HomeScreen.routeName,
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    path: '/creadorGrupo',
    name: CreadorGrupos.routename,
    builder: (context, state) => const CreadorGrupos(),
  ),
  GoRoute(
    path: '/group',
    name: GroupScreen.routename,
    builder: (context, state) => const GroupScreen(),
  ),
  GoRoute(
    path: '/join',
    name: JoinScreen.routename,
    builder: (context, state) => const JoinScreen(),
  ),
  GoRoute(
    path: '/joinPassword',
    name: JoinPassword.routename,
    builder: (context, state) => const JoinPassword(),
  ),

]);
