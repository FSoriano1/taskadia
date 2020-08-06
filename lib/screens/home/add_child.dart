import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taro/models/user.dart';
import 'package:taro/services/auth.dart';
import 'package:taro/services/database.dart';
import 'package:taro/shared/loading.dart';

class Add_Child extends StatefulWidget {
  final Function toggleView;
  Add_Child({this.toggleView});
  @override
  _Add_ChildState createState() => _Add_ChildState();
}

class _Add_ChildState extends State<Add_Child> {
  @override
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  int index;
  String username = '';
  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<User>(context);
    List<User> users = Provider.of<List<User>>(context);
    for (int i = 0; i < users.length; i++) {
      if (currentUser.uid == users[i].uid) {
        index = i;
      }
    }
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Stack(children: <Widget>[
              Container(
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          image: new AssetImage('images/background.png'),
                          fit: BoxFit.cover)),
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          Text(
                            'Add',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Child Account',
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
                                hintText: 'username',
                              ),
                              style: TextStyle(color: Colors.white),
                              validator: (val) =>
                                  val.isEmpty ? 'Enter an username!' : null,
                              onChanged: (val) {
                                setState(() {
                                  error = '';
                                  username = val;
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
                                child: Text('Add Account',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17.5)),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    dynamic result =
                                        await _auth.registerChildEmailPassword(
                                            currentUser.uid,
                                            users[index].email,
                                            users[index].password,
                                            email,
                                            password,
                                            username);
                                    if (result == null) {
                                      setState(() {
                                        error = 'Email is not valid!';
                                        loading = false;
                                      });
                                    } else {
                                      users = Provider.of<List<User>>(context);
                                      print(users.length);
                                      int index2;
                                      for (int i = 0; i < users.length; i++) {
                                        if (users[i].partnerUid ==
                                            users[index].uid) {
                                          index2 = i;
                                        }
                                      }
                                      print(index2);
                                      print(index);
                                      await DatabaseService()
                                          .updateCurrentUserData(
                                              users[index].uid,
                                              users[index].username,
                                              1,
                                              -1,
                                              users[index2].uid,
                                              users[index].email,
                                              users[index].password);
                                      await DatabaseService()
                                          .updateCurrentUserData(
                                              users[index2].uid,
                                              users[index2].username,
                                              2,
                                              0,
                                              users[index].uid,
                                              users[index2].email,
                                              users[index2].password);
                                      widget.toggleView(3);
                                    }
                                  }
                                }),
                          ),
                          SizedBox(height: 12.0),
                          Text(error,
                              style: TextStyle(
                                  color: Colors.red[150], fontSize: 14.0)),
                          SizedBox(height: 20.0),
                          RaisedButton(
                              color: Colors.grey[400],
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                widget.toggleView(3);
                              }),
                        ],
                      ))),
            ]));
  }
}
