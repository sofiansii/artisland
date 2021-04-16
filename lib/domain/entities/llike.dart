class Like {
  String name;
  String image;
  String uid;
  Like(this.uid, this.name, this.image);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is Like &&
        other.uid == uid &&
        other.image == image &&
        other.name == name;
  }
}
