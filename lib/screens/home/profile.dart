import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taro/models/user.dart';
import 'package:taro/services/auth.dart';

class Profile extends StatefulWidget {
  final Function toggleView;
  Profile({this.toggleView});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  String error = '';
  void _changeScreen(int index) {
    if (index == 0) {
      widget.toggleView(1);
    }
    if (index == 1) {
      widget.toggleView(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    int index;
    int childIndex;
    final currentUser = Provider.of<User>(context);
    final users = Provider.of<List<User>>(context);
    for (int i = 0; i < users.length; i++) {
      if (currentUser.uid == users[i].uid) {
        index = i;
      }
    }
    for (int j = 0; j < users.length; j++) {
      if (users[index].partnerUid == users[j].uid) {
        childIndex = j;
      }
    }
    return Scaffold(
      appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: Colors.green[300],
          elevation: 0.0),
      body: Stack(children: <Widget>[
        Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage('images/background.png'),
                    fit: BoxFit.cover)),
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Card(
                    margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('YOU',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 10.0),
                            Text('Username:',
                                style: TextStyle(color: Colors.black)),
                            SizedBox(width: 10.0),
                            Text(users[index].username ?? 'poo',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 10.0),
                            Text('Email:',
                                style: TextStyle(color: Colors.black)),
                            SizedBox(width: 10.0),
                            Text(users[index].email ?? 'pee',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 20.0),
                      ],
                    )),
                Card(
                    margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                                users[index].type == 1
                                    ? 'CHILD ACCOUNT'
                                    : 'PARENT ACCOUNT',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 10.0),
                            Text('Username:',
                                style: TextStyle(color: Colors.black)),
                            SizedBox(width: 10.0),
                            Text(
                                childIndex == null
                                    ? 'None'
                                    : users[childIndex].username,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 10.0),
                            Text('Email:',
                                style: TextStyle(color: Colors.black)),
                            SizedBox(width: 10.0),
                            Text(
                                childIndex == null
                                    ? 'None'
                                    : users[childIndex].email,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 20.0),
                      ],
                    )),
                SizedBox(height: 30.0),
                RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green[300])),
                    color: Colors.green[300],
                    child: Text('Add Child Account',
                        style: TextStyle(color: Colors.white, fontSize: 17.5)),
                    onPressed: () async {
                      if (childIndex != null) {
                        error = 'You already have a child account!';
                      } else {
                        widget.toggleView(6);
                      }
                    }),
                SizedBox(height: 30.0),
                RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red[400])),
                    color: Colors.red[400],
                    child: Text('Sign Out',
                        style: TextStyle(color: Colors.white, fontSize: 17.5)),
                    onPressed: () async {
                      await _auth.signOut();
                    }),
              ],
            )),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Feed')),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_mall), title: Text('Shop')),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), title: Text('Profile')),
        ],
        currentIndex: 2,
        selectedItemColor: Colors.green[300],
        onTap: _changeScreen,
      ),
    );
  }
}
