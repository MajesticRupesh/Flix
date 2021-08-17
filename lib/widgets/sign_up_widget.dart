import 'package:flutter/material.dart';
import 'google_signup_button_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpWidget extends StatelessWidget {
  final Widget svg = SvgPicture.asset('assets/loginasset.svg');
  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          svg,
          buildSignUp(),
        ],
      );

  Widget buildSignUp() => Column(
        children: [
          Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: 175,
              child: Text(
                'Welcome to Flix',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Spacer(),
          GoogleSignupButtonWidget(),
          Spacer(),
        ],
      );
}
