import 'package:allyoucaneattogether/models/order.dart';
import 'package:allyoucaneattogether/utils/random_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  static const codeLength = 5;

  final String? uid;
  final String code;
  List<Order> orders = [];

  Group({this.uid, String? code, this.orders = const []})
      : code = code ?? randomString(Group.codeLength).toUpperCase() {
    if (this.code.length != codeLength) {
      throw FormatException(
          'Group code length must be at least $codeLength [${this.code}]');
    }
  }

  factory Group.fromJson(String uid, Map<String, dynamic> json) =>
      _groupFromJson(uid, json);

  factory Group.fromSnapshot(DocumentSnapshot snapshot) {
    return Group.fromJson(
      snapshot.reference.id,
      snapshot.data() as Map<String, dynamic>,
    );
  }

  static Group _groupFromJson(String uid, Map<String, dynamic> json) {
    return Group(
      uid: uid,
      code: json['code'] as String,
    );
  }

  Map<String, dynamic> toJson() => _groupToJson(this);

  Map<String, dynamic> _groupToJson(Group instance) => <String, dynamic>{
        'code': instance.code,
      };
}
