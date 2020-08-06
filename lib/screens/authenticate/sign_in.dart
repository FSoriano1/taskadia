import 'package:flutter/material.dart';
import 'package:taro/services/auth.dart';
import 'package:taro/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String username = '';
  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: Stack(children: <Widget>[
            Container(
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: new AssetImage('images/background.png'),
                        fit: BoxFit.cover)),
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        Text(
                          'Sign In to Taskadia',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 40.0),
                        TextFormField(
                            decoration: InputDecoration(
                              hintText: 'email',
                            ),
                            style: TextStyle(color: Colors.white),
                            validator: (val) =>
                                val.isEmpty ? 'Enter an email!' : null,
                            onChanged: (val) {
                              setState(() {
                                error = '';
                                email = val;
                              });
                            }),
                        SizedBox(height: 40.0),
                        TextFormField(
                            decoration: InputDecoration(
                              hintText: 'password',
                            ),
                            style: TextStyle(color: Colors.white),
                            obscureText: true,
                            validator: (val) => val.length < 6
                                ? 'Password must be at least 6 chars long!'
                                : null,
                            onChanged: (val) {
                              setState(() {
                                error = '';
                                password = val;
                              });
                            }),
                        SizedBox(height: 30.0),
                        ButtonTheme(
                          minWidth: 150.0,
                          height: 35.0,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.green[300])),
                              color: Colors.green[300],
                              child: Text('Sign In',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17.5)),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  dynamic result = await _auth
                                      .signInEmailPassword(email, password);
                                  print(result);
                                  if (result == null) {
                                    setState(() {
                                      error = 'Email is not valid!';
                                      loading = false;
                                    });
                                  } else {}
                                }
                              }),
                        ),
                        SizedBox(height: 12.0),
                        Text(error,
                            style: TextStyle(
                                color: Colors.red[150], fontSize: 14.0)),
                        SizedBox(height: 20.0),
                        Text('Don\'t have an account?',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0)),
                        FlatButton(
                          child: Text('Register here',
                              style: TextStyle(
                                  color: Colors.green[200], fontSize: 16.0)),
                          onPressed: () {
                            widget.toggleView(2);
                          },
                        )
                      ],
                    ))),
          ]));
  }
}
