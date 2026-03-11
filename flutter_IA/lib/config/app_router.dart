import 'package:flutter_ia/presentation/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

final goRouter = GoRouter(
  navigatorKey: Get.key,
  initialLocation: '/',
  routes: [GoRoute(path: '/', builder: (context, state) => HomeScreen())],
);
