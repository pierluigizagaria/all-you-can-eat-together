import 'package:allyoucaneattogether/models/order.dart';
import 'package:allyoucaneattogether/models/user.dart';
import 'package:allyoucaneattogether/utils/random_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  factory Group.fromSnapshot(DocumentSnapshot snapshot) => Group.fromJson(
      snapshot.reference.id, snapshot.data() as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _groupToJson(this);

  Map<String, dynamic> _groupToJson(Group instance) => <String, dynamic>{
        'code': instance.code,
        'orders': instance.orders.map((e) => e.toJson()).toList(),
      };

  static Group _groupFromJson(String uid, Map<String, dynamic> json) => Group(
        uid: uid,
        code: json['code'] as String,
        orders: _ordersFromJson(json['orders'] as List<dynamic>),
      );

  static List<Order> _ordersFromJson(List<dynamic> orderMaps) => orderMaps
      .map((orderJson) => Order.fromJson(orderJson as Map<String, dynamic>))
      .toList();

  List<Order> mockOrders() {
    return [
      Order(
          user: UserData(uid: '', name: 'Pierluigi'),
          color: Colors.blue,
          items: [1, 2, 3, 4, 12]),
      Order(
          user: UserData(uid: '', name: 'Pierluigi'),
          color: Colors.amber,
          items: [1, 2, 3]),
      Order(
          user: UserData(uid: '', name: 'Pierluigi'),
          color: Colors.red,
          items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]),
    ];
  }
}
