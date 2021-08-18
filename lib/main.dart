import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/movielist.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();
  Hive.registerAdapter(MovieListAdapter());
  await Hive.openBox<MovieList>('movies');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Flix';

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: new ThemeData(canvasColor: Color.fromRGBO(46, 46, 46, 1), brightness: Brightness.dark),
        debugShowCheckedModeBanner: false,
        title: title,
        home: HomePage(),
      );
}
