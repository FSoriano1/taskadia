import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taro/models/task.dart';
import 'package:taro/models/user.dart';
import 'package:taro/services/auth.dart';
import 'package:taro/services/database.dart';

class Feed extends StatefulWidget {
  final Function toggleView;
  final Function toggleTask;
  Feed({this.toggleView, this.toggleTask});
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  void _changeScreen(int index) {
    if (index == 2) {
      widget.toggleView(3);
    }
    if (index == 1) {
      widget.toggleView(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<List<Task>>(context) ?? [];
    int month;
    int day;
    int coins;
    int index2;
    int index3;
    Color clr = Colors.green[300];
    List<Task> sortedTasks = new List<Task>(tasks.length);
    for (int i = 0; i < tasks.length; i++) {
      sortedTasks[i] = tasks[i];
    }
    sortedTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    final currentUser = Provider.of<User>(context);
    final users = Provider.of<List<User>>(context);
    if (users != null) {
      for (int i = 0; i < users.length ?? 0; i++) {
        print(currentUser.uid);
        if (currentUser.uid == users[i].uid) {
          index2 = i;
        }
      }
      for (int i = 0; i < users.length ?? 0; i++) {
        if (users[index2].uid == users[i].partnerUid) {
          index3 = i;
          print('cat');
        }
      }
    }

    if (users != null && users[index2].type == 1) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
              users[index2].type == 1 ? ' ' : users[index2].coins.toString()),
          backgroundColor: Colors.green[300],
          elevation: 0.0,
        ),
        body: Stack(children: <Widget>[
          Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage('images/background.png'),
                    fit: BoxFit.cover)),
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  coins = sortedTasks[index].coins;
                  if (sortedTasks[index].dueDate != 400) {
                    month = sortedTasks[index].month;
                    day = sortedTasks[index].day;
                  }
                  return Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Card(
                          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 10.0),
                              Text(sortedTasks[index].dueDate == 400
                                  ? ' '
                                  : 'Due by $month/$day'),
                              ListTile(
                                title: Text(sortedTasks[index].title,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle:
                                    Text(sortedTasks[index].description ?? ' '),
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
                                    child: Text('ACCEPT',
                                        style: TextStyle(
                                            color: sortedTasks[index].complete
                                                ? Colors.black
                                                : Colors.white)),
                                    color: sortedTasks[index].complete
                                        ? Colors.green[300]
                                        : Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        if (sortedTasks[index].complete) {
                                          DatabaseService()
                                              .updateCurrentUserData(
                                                  users[index3].uid,
                                                  users[index3].username,
                                                  users[index3].type,
                                                  (users[index3].coins +
                                                      sortedTasks[index].coins),
                                                  users[index3].partnerUid,
                                                  users[index3].email,
                                                  users[index3].password);
                                          DatabaseService().deleteTask(
                                              sortedTasks[index].docId);
                                        }
                                      });
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('DENY',
                                        style: TextStyle(
                                            color: sortedTasks[index].complete
                                                ? Colors.black
                                                : Colors.white)),
                                    color: sortedTasks[index].complete
                                        ? Colors.green[300]
                                        : Colors.white,
                                    onPressed: () async {
                                      setState(() {
                                        if (sortedTasks[index].complete) {
                                          DatabaseService().updateTask(
                                              sortedTasks[index].docId,
                                              sortedTasks[index].title,
                                              sortedTasks[index].description,
                                              sortedTasks[index].month,
                                              sortedTasks[index].day,
                                              sortedTasks[index].dueDate,
                                              sortedTasks[index].coins,
                                              false);
                                        }
                                      });
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('EDIT'),
                                    color: clr,
                                    onPressed: () {
                                      setState(() {
                                        widget.toggleTask(
                                            sortedTasks[index].docId);
                                        widget.toggleView(4);
                                      });
                                    },
                                  ),
                                ],
                              )
                            ],
                          )));
                }),
          ),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              widget.toggleTask('');
              widget.toggleView(4);
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
          currentIndex: 0,
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
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  coins = sortedTasks[index].coins;
                  if (sortedTasks[index].dueDate != 400) {
                    month = sortedTasks[index].month;
                    day = sortedTasks[index].day;
                  }
                  return Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Card(
                          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 10.0),
                              Text(sortedTasks[index].dueDate == 400
                                  ? ' '
                                  : 'Due by $month/$day'),
                              ListTile(
                                title: Text(sortedTasks[index].title,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle:
                                    Text(sortedTasks[index].description ?? ' '),
                              ),
                              Row(
                                children: <Widget>[
                                  SizedBox(width: 15.0),
                                  Text("Reward:"),
                                  SizedBox(width: 5.0),
                                  Image.asset('images/coin.png',
                                      height: 15.0, width: 15.0),
                                  Text(coins.toString())
                                ],
                              ),
                              ButtonBar(
                                children: <Widget>[
                                  FlatButton(
                                    child: Text('COMPLETE'),
                                    color: sortedTasks[index].complete
                                        ? Colors.grey[300]
                                        : Colors.green[300],
                                    onPressed: () async {
                                      setState(() {
                                        DatabaseService().updateTask(
                                            sortedTasks[index].docId,
                                            sortedTasks[index].title,
                                            sortedTasks[index].description,
                                            sortedTasks[index].month,
                                            sortedTasks[index].day,
                                            sortedTasks[index].dueDate,
                                            sortedTasks[index].coins,
                                            true);
                                      });
                                    },
                                  )
                                ],
                              )
                            ],
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
          currentIndex: 0,
          selectedItemColor: Colors.green[300],
          onTap: _changeScreen,
        ),
      );
    }
  }
}
