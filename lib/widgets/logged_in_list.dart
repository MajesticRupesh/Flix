import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart';
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
    return MaterialApp(
      theme: new ThemeData(canvasColor: Color.fromRGBO(46, 46, 46, 1)),
      debugShowCheckedModeBanner: false,
      home: LoggedIn(),
    );
  }
}

class LoggedIn extends StatefulWidget {
  @override
  _LoggedInState createState() => _LoggedInState();
}

class _LoggedInState extends State<LoggedIn> {
  ScrollController controller = ScrollController();

  final List<MovieList> movies = [];
  List<dynamic> responseList = FOOD_DATA;

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
    final Size size = MediaQuery.of(context).size;
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
        body: Container(
          height: size.height,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: responseList.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: new Key(responseList[index]["name"]),
                      onDismissed: (direction) {
                        setState(() {
                          responseList.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: new Text("Dismissed")));
                      },
                      background: Container(color: Colors.red),
                      child: Container(
                        height: 120,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          color: Color.fromRGBO(30, 30, 30, 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 200,
                                    child: Text(
                                      responseList[index]["name"],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    responseList[index]["director"],
                                    style: const TextStyle(fontSize: 17, color: Color.fromRGBO(240, 240, 240, 1)),
                                  ),
                                ],
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  "assets/${responseList[index]["image"]}",
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => MovieListDialog(
              onClickedDone: addMovie,
            ),
          ),
          child: const Icon(Icons.add),
          backgroundColor: Colors.purple,
        ),
      ),
    );
  }

  Future addMovie(String name, String director, double rating) async {
    final transaction = MovieList()
      ..name = name
      ..director = director
      ..rating = rating;

    final box = Boxes.getTransactions();
    box.add(transaction);
    //box.put('mykey', transaction);

    // final mybox = Boxes.getTransactions();
    // final myTransaction = mybox.get('key');
    // mybox.values;
    // mybox.keys;
  }
}
