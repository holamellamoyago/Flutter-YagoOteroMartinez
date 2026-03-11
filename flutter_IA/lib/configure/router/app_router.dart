import 'package:go_router/go_router.dart';
import 'package:plantilla_flutter/presentation/home_screen.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    name: HomeScreen.routeName,
    builder: (context, state) => const HomeScreen(),
  ),
]);
