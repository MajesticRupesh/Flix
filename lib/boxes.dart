import 'package:hive/hive.dart';
import 'models/movielist.dart';

class Boxes {
  static Box<MovieList> getTransactions() => Hive.box<MovieList>('movies');
}
