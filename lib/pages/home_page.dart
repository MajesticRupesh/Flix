import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../provider/google_sign_in.dart';
import '../widgets/logged_in_list.dart';
import '../widgets/sign_up_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  final Widget svg = SvgPicture.asset('assets/loginasset.svg');
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final provider = Provider.of<GoogleSignInProvider>(context);

              if (provider.isSigningIn) {
                return buildLoading();
              } else if (snapshot.hasData) {
                return LoggedInWidget();
              } else {
                return SignUpWidget();
              }
            },
          ),
        ),
      );

  Widget buildLoading() => Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            svg,
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(top: 50),
                child: Center(
                  child: Text(
                    'Welcome to Flix',
                    style: TextStyle(
                      color: Color.fromRGBO(240, 240, 240, 1),
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: Text(
                  'Your very own movie list. Add/Delete/Edit your list in a jiffy with Flex.',
                  style: TextStyle(
                    color: Color.fromRGBO(200, 200, 200, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
