

import 'package:english_by_holamellamoyago/presentation/screens.dart';
import 'package:english_by_holamellamoyago/presentation/screens/fail_screen.dart';

final appRouter = GoRouter(initialLocation: '/failScreen', routes: [
  GoRoute(
    path: '/',
    name: HomeScreen.routeName,
    builder: (context, state) => const HomeScreen(),
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
