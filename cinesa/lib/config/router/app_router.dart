import 'package:cinesa/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(

  initialLocation: "/home/0",
  routes: [
    // Rutas padre/hijo
    GoRoute(
      path: "/home/:page",
      name: HomeScreen.name,
      builder: (context, state) {
        final pageIndex = state.pathParameters['page'] ?? '0';
        // final pageIndex2 = int.parse(state.pathParameters['page'] ?? '0');

        return HomeScreen(pageIndex: int.parse(pageIndex));
      },
      routes: [
        GoRoute(
          path: "/movie/:id",
          name: MovieScreen.name,
          builder: (context, state) {
            final movieId = state.pathParameters['id'] ?? 'no-id';
            return MovieScreen(movieId: movieId);
          },
        ),
      ],
    ),

    GoRoute(path: '/',
    redirect: (_, _) => '/home/0',)
  ],
);
