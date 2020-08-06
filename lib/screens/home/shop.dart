import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taro/models/item.dart';
import 'package:taro/models/user.dart';
import 'package:taro/services/database.dart';

class Shop extends StatefulWidget {
  final Function toggleView;
  final Function toggleItem;
  Shop({this.toggleView, this.toggleItem});
  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  void _changeScreen(int index) {
    if (index == 2) {
      widget.toggleView(3);
    }
    if (index == 0) {
      widget.toggleView(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<List<Item>>(context) ?? [];
    int coins;

    int index2;
    Color clr = Colors.green[300];

    final currentUser = Provider.of<User>(context);
    final users = Provider.of<List<User>>(context);
    if (users != null) {
      for (int i = 0; i < users.length ?? 0; i++) {
        if (currentUser.uid == users[i].uid) {
          index2 = i;
        }
      }
    }
    if (users != null && users[index2].type == 1) {
      return Scaffold(
        appBar: AppBar(
            title: Text(
                users[index2].type == 1 ? ' ' : users[index2].coins.toString()),
            backgroundColor: Colors.green[300],
            elevation: 0.0),
        body: Stack(children: <Widget>[
          Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage('images/background.png'),
                    fit: BoxFit.cover)),
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  coins = items[index].coins;
                  return Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Card(
                          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                          child: Container(
                            color: Colors.yellow[300],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 10.0),
                                ListTile(
                                  title: Text(items[index].title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle:
                                      Text(items[index].description ?? ' '),
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(width: 15.0),
                                    Text("Costs"),
                                    SizedBox(width: 5.0),
                                    Image.asset('images/coin.png',
                                        height: 15.0, width: 15.0),
                                    Text(coins.toString())
                                  ],
                                ),
                                ButtonBar(
                                  children: <Widget>[
                                    FlatButton(
                                      child: Text('OK',
                                          style: TextStyle(
                                              color: items[index].bought
                                                  ? Colors.black
                                                  : Colors.yellow[300])),
                                      color: items[index].bought
                                          ? Colors.green[300]
                                          : Colors.yellow[300],
                                      onPressed: () {
                                        if (items[index].bought == true) {
                                          setState(() {
                                            DatabaseService()
                                                .deleteItem(items[index].docId);
                                          });
                                        }
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('EDIT',
                                          style: TextStyle(
                                              color: items[index].bought
                                                  ? Colors.yellow[300]
                                                  : Colors.black)),
                                      color: items[index].bought
                                          ? Colors.yellow[300]
                                          : Colors.green[300],
                                      onPressed: () {
                                        if (items[index].bought == false) {
                                          setState(() {
                                            widget
                                                .toggleItem(items[index].docId);
                                            widget.toggleView(7);
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )));
                }),
          ),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              widget.toggleItem('');
              widget.toggleView(7);
            });
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.green[300],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('Feed')),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_mall), title: Text('Shop')),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), title: Text('Profile')),
          ],
          currentIndex: 1,
          selectedItemColor: Colors.green[300],
          onTap: _changeScreen,
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
            title: Row(children: <Widget>[
              Image.asset('images/coin.png', height: 25.0, width: 25.0),
              SizedBox(width: 5.0),
              Text(users != null && users[index2].type == 1
                  ? ' '
                  : users != null ? users[index2].coins.toString() : ' '),
            ]),
            backgroundColor: Colors.green[300],
            elevation: 0.0),
        body: Stack(children: <Widget>[
          Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage('images/background.png'),
                    fit: BoxFit.cover)),
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  coins = items[index].coins;
                  return Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Card(
                          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                          child: Container(
                            color: Colors.yellow[300],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 10.0),
                                ListTile(
                                  title: Text(items[index].title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle:
                                      Text(items[index].description ?? ' '),
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(width: 15.0),
                                    Text("Costs"),
                                    SizedBox(width: 5.0),
                                    Image.asset('images/coin.png',
                                        height: 15.0, width: 15.0),
                                    Text(coins.toString())
                                  ],
                                ),
                                ButtonBar(
                                  children: <Widget>[
                                    FlatButton(
                                      child: Text('BUY'),
                                      color: items[index].bought
                                          ? Colors.grey[300]
                                          : Colors.green[300],
                                      onPressed: () async {
                                        setState(() {
                                          if (users[index2].coins >=
                                              items[index].coins)
                                            DatabaseService().updateItem(
                                                items[index].docId,
                                                items[index].title,
                                                items[index].description,
                                                items[index].coins,
                                                true);
                                          DatabaseService()
                                              .updateCurrentUserData(
                                                  users[index2].uid,
                                                  users[index2].username,
                                                  users[index2].type,
                                                  (users[index2].coins -
                                                      items[index].coins),
                                                  users[index2].partnerUid,
                                                  users[index2].email,
                                                  users[index2].password);
                                        });
                                      },
                                    )
                                  ],
                                )
                              ],
                            ),
                          )));
                }),
          ),
        ]),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('Feed')),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_mall), title: Text('Shop')),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), title: Text('Profile')),
          ],
          currentIndex: 1,
          selectedItemColor: Colors.green[300],
          onTap: _changeScreen,
        ),
      );
    }
  }
}
