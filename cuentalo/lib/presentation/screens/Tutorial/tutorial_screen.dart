import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cuentalo/presentation/screens.dart';
import 'package:dynamic_background/dynamic_background.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class SlideInfo {
  final String title;
  final String caption;
  final String imageURL;
  final int id;

  SlideInfo(this.title, this.caption, this.imageURL, this.id);
}

final slides = <SlideInfo>[
  SlideInfo(
      'Eres de los que mas bebes ?!',
      'CUENTALO',
      'assets/presentacion1.png',
      1),
  SlideInfo(
      'Eres de los que mas f*llas ?!',
      'CUENTALO',
      'assets/presentacion2.png',
      2),
  SlideInfo(
      'O un pajero ?!',
      'CUENTALO',
      'assets/presentacion3.png',
      3),
];

class TutorialScreen extends StatefulWidget {
  static const routename = '/tutorial';
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController pageviewController = PageController();
  bool endReached = false;

  @override
  void initState() {
    super.initState();
    pageviewController.addListener(() {
      final page = pageviewController.page ?? 0;
      print(page);
      print('Hola');

      if (!endReached && page >= (slides.length - 1.5)) {
        setState(() {
          endReached = true;
          print(page);
          print('Cambio');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DynamicBg(
        painterData: ScrollerPainterData(
            shape: ScrollerShape.diamonds,
            fadeEdges: true,
            shapeOffset: ScrollerShapeOffset.shift,
            color: Colors.grey[400]!,
            backgroundColor: Colors.grey[200]!),
        child: Center(
          child: BlurryContainer(
            blur: 11,
            height: 80.h,
            width: 70.w,
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: pageviewController,
                    physics: const BouncingScrollPhysics(),
                    children: slides
                        .map(
                          (slideData) => _Slide(
                              title: slideData.title,
                              caption: slideData.caption,
                              imageURL: slideData.imageURL,
                              id: slideData.id),
                        )
                        .toList(),
                  ),
                ),
                if (endReached)
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _ButtonLogin(),
                      ],
                    ),
                  )
                else
                  const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class _ButtonLogin extends StatelessWidget {
  const _ButtonLogin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: FilledButton(
        child: const Text('Login'),
        onPressed: () {
          context.push('/login');
        },
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final String title;
  final String caption;
  final String imageURL;
  final int id;

  const _Slide({
    super.key,
    required this.title,
    required this.caption,
    required this.imageURL,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    final captionStyle = Theme.of(context).textTheme.bodySmall;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           SizedBox(height: 5.h),
            Image.asset(
              imageURL,
            ),
            TitleLargeCustom(
              titulo: title,
            ),
            const SizedBox(height: 10),
            Text('CUENTALO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),),
            SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CirclePageIndicator(
                    selectedDotColor: colors.primary,
                    currentPageNotifier: ValueNotifier(id - 1),
                    itemCount: slides.length,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
