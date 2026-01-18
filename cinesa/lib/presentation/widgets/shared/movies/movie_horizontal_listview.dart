import 'package:animate_do/animate_do.dart';
import 'package:cinesa/config/helpers/human_formats.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../../../domain/entities/movie.dart';

class MovieHorizontalListview extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final String? subtitle;

  final VoidCallback? loadNextPage;

  const MovieHorizontalListview({
    super.key,
    required this.movies,
    this.title,
    this.subtitle,
    this.loadNextPage,
  });

  @override
  State<MovieHorizontalListview> createState() =>
      _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;

      if ((scrollController.position.pixels + 200) >=
          scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.h,
      child: Column(
        children: [
          if (widget.title != null || widget.subtitle != null)
            _Title(widget.title, widget.subtitle),

          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) =>
                  FadeInRight(child: _Slide(widget.movies[index])),
            ),
          ),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;

  const _Slide(this.movie);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Container(
      width: 40.w,
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen
          SizedBox(
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.all(Radius.circular(16)),
              child: Image.network(
                fit: BoxFit.cover,
                movie.posterPath,
                width: 40.w,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return GestureDetector(
                    onTap: () => context.push('/movie/${movie.id}'),
                    child: FadeInRight(child: child),
                  );
                },
              ),
            ),
          ),

          SizedBox(height: 1.h),
          // Titulo a partir de aquí
          SizedBox(
            width: 40.w,
            child: Text(movie.title, maxLines: 2, style: textStyle.titleSmall),
          ),

          // Estrellas  + visualizaciones
          Row(
            children: [
              Icon(Icons.star_half_outlined, color: Colors.yellow.shade800),
              SizedBox(width: 1.w),
              Text(
                movie.voteAverage.toString(),
                style: textStyle.bodyMedium?.copyWith(
                  color: Colors.yellow.shade800,
                ),
              ),
              Spacer(),
              Text(
                HumanFormats.number((movie.popularity) * 1000),
                style: textStyle.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const _Title(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    final buttonStyle = ButtonStyle(visualDensity: VisualDensity.comfortable);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          if (title != null) Text(title!, style: titleStyle),
          Spacer(),
          if (subtitle != null)
            FilledButton.tonal(
              onPressed: () {},
              style: buttonStyle,
              child: Text(subtitle!),
            ),
        ],
      ),
    );
  }
}
