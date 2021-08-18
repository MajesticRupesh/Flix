import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../provider/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flix/models/movielist.dart';
import 'movie_dialog.dart';
import 'package:flix/boxes.dart';

class LoggedInWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.black));
    return LoggedIn();
  }
}

class LoggedIn extends StatefulWidget {
  @override
  _LoggedInState createState() => _LoggedInState();
}

class _LoggedInState extends State<LoggedIn> {
  ScrollController controller = ScrollController();

  final List<MovieList> movies = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Hive.box('movies').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final profpic = NetworkImage(user!.photoURL!);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(image: AssetImage("assets/bk.jpg"), fit: BoxFit.cover),
                ),
                child: Center(
                  child: Column(children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: profpic,
                    ),
                    Text(
                      user.displayName!,
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(220, 53, 69, 1),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                      provider.logout();
                    },
                    child: Text('Logout'),
                  ),
                ),
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
            "My Movie List",
            style: const TextStyle(color: Colors.white),
          ),
          elevation: 0,
          backgroundColor: Colors.black,
        ),
        body: ValueListenableBuilder<Box<MovieList>>(
          valueListenable: Boxes.getMovies().listenable(),
          builder: (context, box, _) {
            final transactions = box.values.toList().cast<MovieList>();

            return buildContent(transactions);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showGeneralDialog(
            context: context,
            pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) => MovieListDialog(
              onClickedDone: addMovie,
            ),
          ),
          child: const Icon(Icons.add),
          backgroundColor: Colors.purple,
        ),
      ),
    );
  }

  Widget buildContent(List<MovieList> movies) {
    if (movies.isEmpty) {
      return Center(
        child: Text(
          'No Movies yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return Column(
        children: [
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: movies.length,
              itemBuilder: (BuildContext context, int index) {
                final movie = movies[index];

                return buildMovie(context, movie);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildMovie(BuildContext context, MovieList movie) {
    return Card(
      color: Color.fromRGBO(40, 40, 40, 1),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(
          movie.name,
          maxLines: 2,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        subtitle: Text(movie.director),
        trailing: Text(
          movie.rating.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        children: [
          buildButtons(context, movie),
        ],
      ),
    );
  }

  Widget buildButtons(BuildContext context, MovieList movie) => Row(
        children: [
          Expanded(
            child: TextButton.icon(
              label: Text('Edit'),
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MovieListDialog(
                    movie: movie,
                    onClickedDone: (name, director, rating) => editMovie(movie, name, director, rating),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              label: Text(
                'Delete',
                style: TextStyle(color: Color.fromRGBO(220, 53, 69, 1)),
              ),
              icon: Icon(Icons.delete, color: Color.fromRGBO(220, 53, 69, 1)),
              onPressed: () => deleteMovie(movie),
            ),
          )
        ],
      );

  Future addMovie(String name, String director, double rating) async {
    final movie = MovieList()
      ..name = name
      ..director = director
      ..rating = rating;

    final box = Boxes.getMovies();
    box.add(movie);
  }

  void editMovie(
    MovieList transaction,
    String name,
    String director,
    double rating,
  ) {
    transaction.name = name;
    transaction.director = director;
    transaction.rating = rating;
    transaction.save();
  }

  void deleteMovie(MovieList transaction) {
    transaction.delete();
  }
}
