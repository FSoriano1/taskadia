import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taro/models/item.dart';
import 'package:taro/models/user.dart';
import 'package:taro/services/database.dart';
import 'package:taro/shared/loading.dart';

class Add_Item extends StatefulWidget {
  final Function toggleView;
  final String itemId;
  Add_Item({this.toggleView, this.itemId});
  @override
  _Add_ItemState createState() => _Add_ItemState();
}

class _Add_ItemState extends State<Add_Item> {
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
    if (widget.itemId != '') {
      return StreamBuilder<Item>(
          stream: DatabaseService().itemFromId(widget.itemId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Item item = snapshot.data;
              if (title == null) {
                title = item.title;
              }
              if (coins == null) {
                coins = item.coins;
              }
              return Scaffold(
                  resizeToAvoidBottomPadding: false,
                  appBar: AppBar(
                      title: Text('Add Shop Item'),
                      backgroundColor: Colors.green[300],
                      elevation: 0.0),
                  body: Stack(
                    children: <Widget>[
                      Container(
                          decoration: new BoxDecoration(
                              image: new DecorationImage(
                                  image:
                                      new AssetImage('images/background.png'),
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
                                          initialValue: item.title,
                                          decoration: InputDecoration(
                                            hintText: 'title',
                                          ),
                                          style: TextStyle(color: Colors.white),
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
                                          initialValue: item.description,
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
                                          initialValue: item.coins.toString(),
                                          decoration: InputDecoration(
                                            hintText: 'amount of coins',
                                          ),
                                          style: TextStyle(color: Colors.white),
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
                                                widget.toggleView(2);
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
                                                      .updateItem(
                                                          widget.itemId,
                                                          title,
                                                          description,
                                                          coins,
                                                          false);
                                                  widget.toggleView(2);
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
          });
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
                                        widget.toggleView(2);
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
                                          await DatabaseService().createItem(
                                            user.uid,
                                            title,
                                            description,
                                            coins,
                                          );
                                          widget.toggleView(2);
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
