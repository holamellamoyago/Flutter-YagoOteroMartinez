import 'package:english_mvvm_provider_clean/config/app_env.dart';
import 'package:english_mvvm_provider_clean/config/app_router.dart';
import 'package:english_mvvm_provider_clean/data/datasources/auth/auth_remote_datasource.dart';
import 'package:english_mvvm_provider_clean/data/datasources/social/social_datasource_impl.dart';
import 'package:english_mvvm_provider_clean/data/datasources/word/file_words_datasource.dart';
import 'package:english_mvvm_provider_clean/data/repositories/auth_repository_impl.dart';
import 'package:english_mvvm_provider_clean/data/repositories/social_respository_impl.dart';
import 'package:english_mvvm_provider_clean/data/repositories/word_repository_impl.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/bottombar_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/carousel_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/clock_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/social_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/themedata_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/auth_viewmodel.dart';
import 'package:english_mvvm_provider_clean/domain/usecases/get_words.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/words_viewmodel.dart';
import 'package:english_mvvm_provider_clean/domain/usecases/save_word_usecase.dart';
import 'package:english_mvvm_provider_clean/domain/usecases/save_words_usecase.dart';
import 'package:english_mvvm_provider_clean/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
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

  final wordDatasource = FileWordsDatasource();
  final wordRepository = LocalWordRepositoryImpl(wordDatasource);
  final getWords = GetWords(wordRepository);
  final saveWord = SaveWordUsecase(wordRepository);
  final saveWords = SaveWordsUsecase(wordRepository);
  
  final socialRepository = SocialRespositoryImpl(
    datasource: SocialDatasourceImpl(),
  );

  final AuthRemoteDatasource userDatasource = AuthRemoteDatasource();
  final AuthRepositoryImpl userRepository = AuthRepositoryImpl(
    remoteDatasource: userDatasource,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => WordsViewModel(getWords, saveWord, saveWords),
        ),
        ChangeNotifierProvider(create: (context) => CarouselViewmodel()),
        ChangeNotifierProvider(create: (context) => ThemedataViewmodel()),
        ChangeNotifierProvider(create: (context) => ClockViewmodel()),
        ChangeNotifierProvider(create: (context) => BottombarViewmodel()),
        ChangeNotifierProvider(
          create: (context) => AuthViewmodel(userRepository),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              SocialViewmodel(socialRepository: socialRepository),
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
    final authProvider = Provider.of<AuthViewmodel>(context);
    var themeData = context.watch<ThemedataViewmodel>();

    return MaterialApp.router(
      theme: themeData.get(),
      routerConfig: AppRouter.createRouter(authProvider),
    );
  }
}
