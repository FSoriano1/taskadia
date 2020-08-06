class Task {
  final String docId;
  final String uid;
  final String title;
  final String description;
  final int month;
  final int day;
  final int dueDate;
  final int coins;
  final bool complete;

  Task(
      {this.docId,
      this.uid,
      this.title,
      this.description,
      this.month,
      this.day,
      this.dueDate,
      this.coins,
      this.complete});
}
