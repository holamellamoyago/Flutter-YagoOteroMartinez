import 'package:cinemapedia/domain/entities/movie.dart';

/* 
  El datasource es el origen de los datos 

  Una clase abstracta es la que no puede ser invocada

  Estas son funciones que dirán que se necesitan, en este caso una que devolvera
  esa y que requiere un número de página que por defecto será de 1 
*/  

abstract class MovieDataSource {
  Future<List<Movie>>getNowPlaying({int page = 1});
}
