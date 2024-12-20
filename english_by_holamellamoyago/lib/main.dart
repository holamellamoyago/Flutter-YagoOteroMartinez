

import 'package:english_by_holamellamoyago/presentation/screens.dart';
import 'package:seo/html/seo_controller.dart';
import 'package:seo/html/tree/widget_tree.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SeoController(
      enabled: true,
      tree: WidgetTree(context: context),
      child: Sizer(
        builder: (context, orientation, deviceType) => MaterialApp.router(
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
