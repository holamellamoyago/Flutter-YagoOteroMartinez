import 'package:english_mvvm_provider_clean/config/app_env.dart';
import 'package:english_mvvm_provider_clean/config/app_router.dart';
import 'package:english_mvvm_provider_clean/data/datasources/auth/firebase_auth_datasource_impl.dart';
import 'package:english_mvvm_provider_clean/data/datasources/database/supabase_database_datasource_impl.dart';
import 'package:english_mvvm_provider_clean/data/datasources/word/supabase_words_datasource.dart';
import 'package:english_mvvm_provider_clean/data/repositories/auth_repository_impl.dart';
import 'package:english_mvvm_provider_clean/data/repositories/supabase_respository_impl.dart';
import 'package:english_mvvm_provider_clean/data/repositories/word_repository_impl.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/bottombar_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/carousel_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/clock_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/levels_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/users_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/themedata_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/auth_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/words_viewmodel.dart';
import 'package:english_mvvm_provider_clean/domain/usecases/log_out_usecase.dart';
import 'package:english_mvvm_provider_clean/domain/usecases/save_word_usecase.dart';
import 'package:english_mvvm_provider_clean/domain/usecases/save_words_usecase.dart';
import 'package:english_mvvm_provider_clean/firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: AppEnv.supabaseURL,
    anonKey: AppEnv.supabaseAnonKey,
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAppCheck.instance.activate(
    // // Para debug/desarrollo en Android
    // androidProvider: AndroidProvider.debug,
    // // Para producción usa: AndroidProvider.playIntegrity
    // // androidProvider: AndroidProvider.playIntegrity,

    // // Para iOS/macOS
    // appleProvider: AppleProvider.appAttest,

    providerAndroid: AndroidDebugProvider());

  // final wordDatasource = FileWordsDatasource();
  final wordDatasource = SupabaseWordsDatasource();

  // final wordRepository = LocalWordRepositoryImpl(wordDatasource);
  final wordRepository = WordRepositoryImpl(wordDatasource);

  // final getWords = GetWords(wordRepository);
  final saveWord = SaveWordUsecase(wordRepository);
  final saveWords = SaveWordsUsecase(wordRepository);

  final databaseRepository = DatabaseRespositoryImpl(
    datasource: SupabaseDatabaseDatasourceImpl(),
  );

  final FirebaseAuthDatasource authDatasource = FirebaseAuthDatasource();
  final AuthRepositoryImpl authRepository = AuthRepositoryImpl(
    firebaseDatasource: authDatasource,
    databaseDatasource: SupabaseDatabaseDatasourceImpl(),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              WordsViewModel(wordRepository, saveWord, saveWords),
        ),
        ChangeNotifierProvider(create: (context) => CarouselViewmodel()),
        ChangeNotifierProvider(create: (context) => ThemedataViewmodel()),
        ChangeNotifierProvider(create: (context) => ClockViewmodel()),
        ChangeNotifierProvider(create: (context) => BottombarViewmodel()),

        ChangeNotifierProvider(
          create: (context) => AuthViewmodel(
            authRepository,
            LogOutUsecase(
              authRepository: authRepository,
              bottombarViewmodel: Provider.of<BottombarViewmodel>(
                context,
                listen: false,
              ),
            ),
          ),
        ),

        ChangeNotifierProvider(
          create: (context) => UsersViewmodel(databaseRepository),
        ),

        ChangeNotifierProvider(
          create: (context) =>
              LevelsViewmodel(databaseRepository, authRepository),
        ),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // NEcesaria la escucha para gerstionar pantallas
    final authProvider = Provider.of<AuthViewmodel>(context, listen: true);
    var themeData = context.watch<ThemedataViewmodel>();

    return MaterialApp.router(
      theme: themeData.get(),
      routerConfig: AppRouter.createRouter(authProvider),
    );
  }
}
