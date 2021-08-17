import 'package:flutter/material.dart';
import 'google_signup_button_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpWidget extends StatelessWidget {
  final Widget svg = SvgPicture.asset(
    'assets/loginasset.svg',
    fit: BoxFit.fitWidth,
  );
  @override
  Widget build(BuildContext context) => Scaffold(
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
            Spacer(),
            GoogleSignupButtonWidget(),
            Spacer(),
          ],
        ),
      );
}
