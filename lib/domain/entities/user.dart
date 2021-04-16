class User {
  String uid;
  String fullName;
  String profileImage;
  String description;
  String backgroundImage;
  String email;
  String sex;

  User({this.uid, this.description, this.fullName, this.backgroundImage, this.profileImage, this.email, this.sex});

  Future<List<User>> getFollowers() async {}
  Future<List<User>> getFollowing() async {}
}
