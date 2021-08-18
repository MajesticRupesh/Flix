import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart';
import '../provider/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(LoggedInWidget());
}

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

  List<Widget> itemsData = [];

  void getPostsData() {
    List<dynamic> responseList = FOOD_DATA;
    List<Widget> listItems = [];
    responseList.forEach((post) {
      listItems.add(
        Container(
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
                        post["name"],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      post["director"],
                      style: const TextStyle(fontSize: 17, color: Color.fromRGBO(240, 240, 240, 1)),
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    "assets/${post["image"]}",
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
    setState(() {
      itemsData = listItems;
    });
  }

  @override
  void initState() {
    super.initState();
    getPostsData();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser;
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
                      backgroundImage: NetworkImage(user!.photoURL!),
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
                      itemCount: itemsData.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        double scale = 1.0;
                        return Opacity(
                          opacity: scale,
                          child: Transform(
                            transform: Matrix4.identity()..scale(scale, scale),
                            alignment: Alignment.bottomCenter,
                            child: Align(heightFactor: 1, alignment: Alignment.topCenter, child: itemsData[index]),
                          ),
                        );
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
