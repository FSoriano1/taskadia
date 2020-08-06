import 'package:flutter/material.dart';

class Choose extends StatefulWidget {
  final Function toggleView;
  Choose({this.toggleView});
  @override
  _ChooseState createState() => _ChooseState();
}

class _ChooseState extends State<Choose> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage('images/background2.png'),
                    fit: BoxFit.cover)),
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 100.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.green[400],
                      child: Text('Register',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        widget.toggleView(2);
                      },
                    ),
                    SizedBox(width: 30.0),
                    RaisedButton(
                      color: Colors.green[400],
                      child: Text('Sign In',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        widget.toggleView(3);
                      },
                    )
                  ],
                )
              ],
            )),
      ],
    ));
  }
}
