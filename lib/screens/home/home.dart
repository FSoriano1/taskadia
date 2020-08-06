import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taro/models/item.dart';
import 'package:taro/models/task.dart';
import 'package:taro/models/user.dart';
import 'package:taro/screens/home/add_child.dart';
import 'package:taro/screens/home/add_item.dart';
import 'package:taro/screens/home/add_task.dart';
import 'package:taro/screens/home/feed.dart';
import 'package:taro/screens/home/notification.dart';
import 'package:taro/screens/home/profile.dart';
import 'package:taro/screens/home/shop.dart';
import 'package:taro/services/database.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String text1 = '';
  String text2 = '';
  int type =
      1; //1=feed, 2=shop, 3=profile, 4=add task, 5=notif, 6=add child, 7=add item
  void toggleView(int x) {
    setState(() {
      type = x;
    });
  }

  void toggleTask(String taskId) {
    setState(() {
      text1 = taskId;
    });
  }

  void toggleItem(String itemId) {
    setState(() {
      text2 = itemId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Task>>.value(
        value: DatabaseService().tasks,
        child: StreamProvider<List<User>>.value(
            value: DatabaseService().users,
            child: StreamProvider<List<Item>>.value(
                value: DatabaseService().items,
                child: type == 1
                    ? Feed(toggleView: toggleView, toggleTask: toggleTask)
                    : type == 2
                        ? Shop(toggleView: toggleView, toggleItem: toggleItem)
                        : type == 3
                            ? Profile(toggleView: toggleView)
                            : type == 4
                                ? Add_Task(
                                    toggleView: toggleView, taskId: text1)
                                : type == 5
                                    ? Notif(toggleView: toggleView)
                                    : type == 6
                                        ? Add_Child(toggleView: toggleView)
                                        : Add_Item(
                                            toggleView: toggleView,
                                            itemId: text2))));
  }
}
