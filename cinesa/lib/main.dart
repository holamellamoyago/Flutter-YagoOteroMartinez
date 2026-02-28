import 'package:cinesa/config/database/database.dart';
import 'package:cinesa/config/router/app_router.dart';
import 'package:cinesa/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // await db
  //     .into(db.favoriteMovies)
  //     .insert(
  //       FavoriteMoviesCompanion.insert(
  //         movieId: 1,
  //         backdropPath: 'backdropPath.png',
  //         posterPath: 'posterPath.png',
  //         originalTitle: 'My first movie',
  //         title: 'Mi primera película',
  //       ),
  //     );

  // await db.update($FavoriteMoviesTable(attachedDatabase))

  // final deleteQuery = db.delete(db.favoriteMovies);
  // await deleteQuery.go();

  // final moviesQuery = await db.select(db.favoriteMovies).get();
  // print(moviesQuery);

  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screentype) => MaterialApp.router(
        routerConfig: appRouter,
        theme: AppTheme().getTheme(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
