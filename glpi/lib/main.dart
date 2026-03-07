import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:glpi/config/app_router.dart';
import 'package:glpi/data/datasources/glpi_api_datasource_impl.dart';
import 'package:glpi/data/repositories/glpi_api_repository_impl.dart';
import 'package:glpi/domain/usecases/glpi_api_usecase.dart';
import 'package:glpi/presentation/controllers/glpi_controller.dart';

Future main() async {
  await dotenv.load(fileName: "client.env");
  // await dotenv.load(fileName: "user.env");

  Get.put(
    GlpiController(
      usecase: GlpiApiUsecase(
        repository: GlpiApiRepositoryImpl(datasource: GlpiApiDatasourceImpl()),
      ),
    ),
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: appRouter);
  }
}
