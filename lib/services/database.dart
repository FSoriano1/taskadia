import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taro/models/item.dart';
import 'package:taro/models/task.dart';
import 'package:taro/models/user.dart';

class DatabaseService {
  final CollectionReference taskCollection =
      Firestore.instance.collection('tasks');

  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  final CollectionReference itemCollection =
      Firestore.instance.collection('items');

  //****************************USERS***************** */

  Future updateCurrentUserData(String uid, String username, int type, int coins,
      String partnerUid, String email, String password) async {
    return await userCollection.document(uid).setData({
      'uid': uid,
      'username': username,
      'type': type,
      'coins': coins,
      'partnerUid': partnerUid,
      'email': email,
      'password': password
    });
  }

  List<User> _userDataListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return User(
          uid: doc.documentID,
          username: doc.data['username'],
          type: doc.data['type'],
          coins: doc.data['coins'],
          partnerUid: doc.data['partnerUid'],
          email: doc.data['email'],
          password: doc.data['password']);
    }).toList();
  }

  //get users stream
  Stream<List<User>> get users {
    return userCollection.snapshots().map(_userDataListFromSnapshot);
  }

  Future createChildUserData(String uid, String username, String partnerUid,
      String email, String password) async {
    return await userCollection.document(uid).setData({
      'uid': uid,
      'username': username,
      'type': 2,
      'coins': 0,
      'partnerUid': partnerUid,
      'email': email,
      'password': password
    });
  }

//**********************TASKS***********************/

  Future createTask(String uid, String title, String description, int month,
      int day, int dueDate, int coins) async {
    return await taskCollection.add({
      'uid': uid,
      'title': title,
      'description': description,
      'month': month,
      'day': day,
      'dueDate': dueDate,
      'coins': coins,
      'complete': false
    });
  }

  Future updateTask(String taskId, String title, String description, int month,
      int day, int dueDate, int coins, bool complete) async {
    return await taskCollection.document(taskId).setData({
      'title': title,
      'description': description,
      'month': month,
      'day': day,
      'dueDate': dueDate,
      'coins': coins,
      'complete': complete
    });
  }

  void deleteTask(String taskId) {
    taskCollection.document(taskId).delete();
  }

  //get tasks stream
  Stream<List<Task>> get tasks {
    return taskCollection.snapshots().map(_tasklistFromSnapshot);
  }

  List<Task> _tasklistFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Task(
          docId: doc.documentID,
          uid: doc.data['uid'],
          title: doc.data['title'],
          description: doc.data['description'] ?? '',
          month: doc.data['month'],
          day: doc.data['day'],
          dueDate: doc.data['dueDate'],
          coins: doc.data['coins'],
          complete: doc.data['complete']);
    }).toList();
  }

  //unique task
  Stream<Task> taskFromId(String taskId) {
    return taskCollection.document(taskId).snapshots().map(_taskFromSnapshot);
  }

  Task _taskFromSnapshot(DocumentSnapshot snapshot) {
    return Task(
        docId: snapshot.documentID,
        uid: snapshot.data['uid'],
        title: snapshot.data['title'],
        description: snapshot.data['description'] ?? '',
        month: snapshot.data['month'],
        day: snapshot.data['day'],
        dueDate: snapshot.data['dueDate'],
        coins: snapshot.data['coins'],
        complete: snapshot.data['complete']);
  }

  //**********************ITEMS***********************/

  Future createItem(
      String uid, String title, String description, int coins) async {
    return await itemCollection.add({
      'uid': uid,
      'title': title,
      'description': description,
      'coins': coins,
      'bought': false
    });
  }

  Future updateItem(String itemId, String title, String description, int coins,
      bool bought) async {
    return await itemCollection.document(itemId).setData({
      'title': title,
      'description': description,
      'coins': coins,
      'bought': bought
    });
  }

  //get tasks stream
  Stream<List<Item>> get items {
    return itemCollection.snapshots().map(_itemlistFromSnapshot);
  }

  List<Item> _itemlistFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Item(
          docId: doc.documentID,
          uid: doc.data['uid'],
          title: doc.data['title'],
          description: doc.data['description'],
          coins: doc.data['coins'],
          bought: doc.data['bought']);
    }).toList();
  }

  //unique item
  Stream<Item> itemFromId(String itemId) {
    return itemCollection.document(itemId).snapshots().map(_itemFromSnapshot);
  }

  void deleteItem(String itemId) {
    itemCollection.document(itemId).delete();
  }

  Item _itemFromSnapshot(DocumentSnapshot snapshot) {
    return Item(
        docId: snapshot.documentID,
        uid: snapshot.data['uid'],
        title: snapshot.data['title'],
        description: snapshot.data['description'] ?? '',
        coins: snapshot.data['coins'],
        bought: snapshot.data['bought']);
  }
}
