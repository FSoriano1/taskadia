class User {
  final String uid;
  final String username;
  final int coins;
  final int type; //1=master, 2=child
  final String partnerUid;
  final String email;
  final String password;

  User(
      {this.uid,
      this.username,
      this.coins,
      this.type,
      this.partnerUid,
      this.email,
      this.password});
}
