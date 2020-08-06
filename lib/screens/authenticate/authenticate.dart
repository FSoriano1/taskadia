import 'package:flutter/material.dart';
import 'package:taro/screens/authenticate/choose.dart';
import 'package:taro/screens/authenticate/register.dart';
import 'package:taro/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  int type = 1; //1=choose, 2=register, 3=sign in
  void toggleView(int x) {
    setState(() {
      type = x;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (type == 1) {
      return Choose(toggleView: toggleView);
    } else if (type == 2) {
      return Register(toggleView: toggleView);
    } else {
      return SignIn(toggleView: toggleView);
    }
  }
}
