

import 'package:english_by_holamellamoyago/presentation/screens.dart';


final appRouter = GoRouter(initialLocation: '/register', routes: [
  GoRoute(
    path: '/',
    name: HomeScreen.routeName,
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    path: '/register',
    name: RegisterScreen.routename,
    builder: (context, state) => const RegisterScreen(),
  ),
  GoRoute(
    path: '/VIrregulares',
    name: VerbosIrregules.routename,
    builder: (context, state) => const VerbosIrregules(),
  ),
  GoRoute(
    path: '/VRegulares',
    name: VerbosRegulares.routename,
    builder: (context, state) => const VerbosRegulares(),
  ),
  GoRoute(
    path: '/failScreen',
    name: FailScreen.routename,
    builder: (context, state) => const FailScreen(),
  )
]);
