import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taro/models/task.dart';
import 'package:taro/models/user.dart';
import 'package:taro/services/database.dart';
import 'package:taro/shared/loading.dart';

class Add_Task extends StatefulWidget {
  final Function toggleView;
  final String taskId;
  Add_Task({this.toggleView, this.taskId});
  @override
  _Add_TaskState createState() => _Add_TaskState();
}

class _Add_TaskState extends State<Add_Task> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String title;
  String description;
  int month;
  int day;
  int dueDate;
  int coins;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (widget.taskId != '') {
      return StreamBuilder<Task>(
              stream: DatabaseService().taskFromId(widget.taskId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Task task = snapshot.data;
                  if (title == null) {
                    title = task.title;
                  }
                  if (dueDate == null) {
                    dueDate = task.dueDate;
                  }
                  if (month == null) {
                    month = task.month;
                  }
                  if (day == null) {
                    day = task.day;
                  }
                  if (coins == null) {
                    coins = task.coins;
                  }
                  return Scaffold(
                      resizeToAvoidBottomPadding: false,
                      appBar: AppBar(
                          title: Text('Add Task'),
                          backgroundColor: Colors.green[300],
                          elevation: 0.0),
                      body: Stack(
                        children: <Widget>[
                          Container(
                              decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                      image: new AssetImage(
                                          'images/background.png'),
                                      fit: BoxFit.cover)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 50.0),
                              child: SingleChildScrollView(
                                  child: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: 20.0),
                                          TextFormField(
                                              initialValue: task.title,
                                              decoration: InputDecoration(
                                                hintText: 'title',
                                              ),
                                              style: TextStyle(
                                                  color: Colors.white),
                                              validator: (val) => val.isEmpty
                                                  ? 'Enter an title!'
                                                  : null,
                                              onChanged: (val) {
                                                setState(() {
                                                  title = val;
                                                });
                                              }),
                                          SizedBox(height: 20.0),
                                          TextFormField(
                                              initialValue: task.description,
                                              decoration: InputDecoration(
                                                hintText: 'description',
                                              ),
                                              style: TextStyle(
                                                  color: Colors.white),
                                              onChanged: (val) {
                                                setState(() {
                                                  description = val;
                                                });
                                              }),
                                          SizedBox(height: 20.0),
                                          TextFormField(
                                              initialValue:
                                                  task.month.toString(),
                                              decoration: InputDecoration(
                                                hintText: 'month',
                                              ),
                                              style: TextStyle(
                                                  color: Colors.white),
                                              validator: (val) => val.isEmpty
                                                  ? 'Enter an month!'
                                                  : null,
                                              onChanged: (val) {
                                                setState(() {
                                                  month = int.parse(val);
                                                });
                                              }),
                                          SizedBox(height: 20.0),
                                          TextFormField(
                                              initialValue: task.day.toString(),
                                              decoration: InputDecoration(
                                                hintText: 'day',
                                              ),
                                              style: TextStyle(
                                                  color: Colors.white),
                                              validator: (val) => val.isEmpty
                                                  ? 'Enter an day!'
                                                  : null,
                                              onChanged: (val) {
                                                setState(() {
                                                  day = int.parse(val);
                                                });
                                              }),
                                          SizedBox(height: 20.0),
                                          TextFormField(
                                              initialValue:
                                                  task.coins.toString(),
                                              decoration: InputDecoration(
                                                hintText: 'amount of coins',
                                              ),
                                              style: TextStyle(
                                                  color: Colors.white),
                                              validator: (val) => val.isEmpty ||
                                                      int.parse(val) > 1000000
                                                  ? 'Invalid amount of coins!'
                                                  : null,
                                              onChanged: (val) {
                                                setState(() {
                                                  coins = int.parse(val);
                                                });
                                              }),
                                          SizedBox(height: 20.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              RaisedButton(
                                                  color: Colors.grey[400],
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () {
                                                    widget.toggleView(1);
                                                  }),
                                              SizedBox(width: 30.0),
                                              RaisedButton(
                                                  color: Colors.green[300],
                                                  child: Text(
                                                    'Submit',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () async {
                                                    if (_formKey.currentState
                                                        .validate()) {
                                                      await DatabaseService()
                                                          .updateTask(
                                                              widget.taskId,
                                                              title,
                                                              description,
                                                              month,
                                                              day,
                                                              ((month * 31) +
                                                                  (day)),
                                                              coins,
                                                              false);
                                                      widget.toggleView(1);
                                                    }
                                                  }),
                                              SizedBox(height: 400.0)
                                            ],
                                          )
                                        ],
                                      ))))
                        ],
                      ));
                } else {
                  return Loading();
                }
              }) ??
          Loading();
    } else {
      return Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
              title: Text('Add Task'),
              backgroundColor: Colors.green[300],
              elevation: 0.0),
          body: Stack(
            children: <Widget>[
              Container(
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          image: new AssetImage('images/background.png'),
                          fit: BoxFit.cover)),
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                  child: SingleChildScrollView(
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 20.0),
                              TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'title',
                                  ),
                                  style: TextStyle(color: Colors.white),
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter an title!' : null,
                                  onChanged: (val) {
                                    setState(() {
                                      title = val;
                                    });
                                  }),
                              SizedBox(height: 20.0),
                              TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'description',
                                  ),
                                  style: TextStyle(color: Colors.white),
                                  onChanged: (val) {
                                    setState(() {
                                      description = val;
                                    });
                                  }),
                              SizedBox(height: 20.0),
                              TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'month',
                                  ),
                                  style: TextStyle(color: Colors.white),
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter an month!' : null,
                                  onChanged: (val) {
                                    setState(() {
                                      month = int.parse(val);
                                    });
                                  }),
                              SizedBox(height: 20.0),
                              TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'day',
                                  ),
                                  style: TextStyle(color: Colors.white),
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter an day!' : null,
                                  onChanged: (val) {
                                    setState(() {
                                      day = int.parse(val);
                                    });
                                  }),
                              TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'amount of coins',
                                  ),
                                  style: TextStyle(color: Colors.white),
                                  validator: (val) =>
                                      val.isEmpty || int.parse(val) > 1000000
                                          ? 'Invalid amount of coins!'
                                          : null,
                                  onChanged: (val) {
                                    setState(() {
                                      coins = int.parse(val);
                                    });
                                  }),
                              SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  RaisedButton(
                                      color: Colors.grey[400],
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        widget.toggleView(1);
                                      }),
                                  SizedBox(width: 30.0),
                                  RaisedButton(
                                      color: Colors.green[300],
                                      child: Text(
                                        'Submit',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          await DatabaseService().createTask(
                                              user.uid,
                                              title,
                                              description,
                                              month,
                                              day,
                                              ((month * 31) + (day)),
                                              coins);
                                          widget.toggleView(1);
                                        }
                                      }),
                                  SizedBox(height: 400.0)
                                ],
                              )
                            ],
                          ))))
            ],
          ));
    }
  }
}
