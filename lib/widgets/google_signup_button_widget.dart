import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../provider/google_sign_in.dart';
import 'package:provider/provider.dart';

class GoogleSignupButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(4),
        child: TextButton.icon(
          label: Text(
            'Sign In With Google',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          style: TextButton.styleFrom(
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            backgroundColor: Color.fromRGBO(255, 23, 85, 1),
          ),
          icon: FaIcon(FontAwesomeIcons.google, color: Colors.white),
          onPressed: () {
            final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
            provider.login();
          },
        ),
      );
}
