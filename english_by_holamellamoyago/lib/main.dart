import 'package:english_by_holamellamoyago/config/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Sizer(
      builder: (context, orientation, deviceType) => MaterialApp.router(
        routerConfig: appRouter,
      ),
    );
  }
}
