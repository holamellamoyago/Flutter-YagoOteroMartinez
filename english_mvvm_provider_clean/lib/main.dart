import 'package:dart_openai/dart_openai.dart';
import 'package:english_mvvm_provider_clean/config/app_env.dart';
import 'package:english_mvvm_provider_clean/config/app_router.dart';
import 'package:english_mvvm_provider_clean/data/datasources/ai/ai_datasource_deepsheek.dart';
import 'package:english_mvvm_provider_clean/data/datasources/auth/firebase_auth_datasource_impl.dart';
import 'package:english_mvvm_provider_clean/data/datasources/database/supabase_database_datasource_impl.dart';
import 'package:english_mvvm_provider_clean/data/datasources/word/supabase_words_datasource.dart';
import 'package:english_mvvm_provider_clean/data/repositories/ai_repositorie_impl.dart';
import 'package:english_mvvm_provider_clean/data/repositories/auth_repository_impl.dart';
import 'package:english_mvvm_provider_clean/data/repositories/supabase_respository_impl.dart';
import 'package:english_mvvm_provider_clean/data/repositories/word_repository_impl.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/bottombar_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/carousel_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/clock_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/ia_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/levels_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/users_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/themedata_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/auth_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/words_viewmodel.dart';
import 'package:english_mvvm_provider_clean/domain/usecases/log_out_usecase.dart';
import 'package:english_mvvm_provider_clean/domain/usecases/save_word_usecase.dart';
import 'package:english_mvvm_provider_clean/domain/usecases/save_words_usecase.dart';
import 'package:english_mvvm_provider_clean/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: AppEnv.supabaseURL,
    anonKey: AppEnv.supabaseAnonKey,
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  OpenAI.apiKey = AppEnv.deepSheekApiKey;
  OpenAI.baseUrl = "https://api.deepseek.com";
  OpenAI.requestsTimeOut = Duration(minutes: 1);

  // // Para debug/desarrollo en Android
  // androidProvider: AndroidProvider.debug,
  // // Para producción usa: AndroidProvider.playIntegrity
  // // androidProvider: AndroidProvider.playIntegrity,

  // // Para iOS/macOS
  // appleProvider: AppleProvider.appAttest,

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

  // Datasources y repositories de AI
  final IARepository = AIRepositorieImpl(datasource: AiDatasourceDeepsheek());

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

        // Día 12/01 - IA
        ChangeNotifierProvider(
          create: (context) => IAViewmodel(repository: IARepository),
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

    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp.router(
          theme: themeData.get(),
          routerConfig: AppRouter.createRouter(authProvider),
        );
      },
    );
  }
}
