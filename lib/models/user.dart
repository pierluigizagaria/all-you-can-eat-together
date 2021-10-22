class User {
  final String uid;
  String name;

  User({required this.uid, this.name = ''});

  factory User.fromJson(json) => _userFromJson(json);

  static User _userFromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => _userToJson(this);

  Map<String, dynamic> _userToJson(User instance) => <String, dynamic>{
        'uid': instance.uid,
        'name': instance.name,
      };
}
