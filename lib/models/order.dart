import 'package:allyoucaneattogether/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Order {
  final String? uid;
  final User user;
  final Color color;
  final List<int> items;

  Order({
    required this.user,
    required this.color,
    this.uid,
    this.items = const [],
  });

  factory Order.fromJson(uid, json) => _orderFromJson(uid, json);

  factory Order.fromSnapshot(DocumentSnapshot snapshot) => Order.fromJson(
      snapshot.reference.id, snapshot.data() as Map<String, dynamic>);

  static Order _orderFromJson(String uid, Map<String, dynamic> json) {
    return Order(
      uid: uid,
      user: User.fromJson(json['user']),
      color: Color(json['color'] as int),
      items: List.castFrom(json['items']),
    );
  }

  Map<String, dynamic> toJson() => _orderToJson(this);

  Map<String, dynamic> _orderToJson(Order instance) => <String, dynamic>{
        'user': instance.user.toJson(),
        'color': instance.color.value,
        'items': instance.items,
      };
}
