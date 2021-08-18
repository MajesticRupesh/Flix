import 'package:hive/hive.dart';
import 'models/movielist.dart';

class Boxes {
  static Box<MovieList> getMovies() => Hive.box<MovieList>('movies');
}
