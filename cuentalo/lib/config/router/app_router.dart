




import 'package:cuentalo/presentation/screens.dart';

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
    path: '/settings',
    name: SettingsScreen.routename,
    builder: (context, state) => const SettingsScreen(),
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
    path: '/createGroupPassword',
    name: CreateGroupPasswordScreen.routename,
    builder: (context, state) => const CreateGroupPasswordScreen(),
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
