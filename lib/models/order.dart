import 'package:allyoucaneattogether/models/user.dart';
import 'package:flutter/cupertino.dart';

class Order {
  final UserData user;
  final Color color;
  final List<int> items;

  Order({required this.user, required this.color, required this.items});

  factory Order.fromJson(json) => _orderFromJson(json);

  static Order _orderFromJson(Map<String, dynamic> json) {
    return Order(
      user: UserData(name: 'name', uid: '1'),
      color: Color(json['color'] as int),
      items: List.castFrom(json['items']),
    );
  }

  Map<String, dynamic> toJson() => _orderToJson(this);

  Map<String, dynamic> _orderToJson(Order instance) => <String, dynamic>{
        'user': 'null',
        'color': instance.color.value,
        'items': instance.items,
      };
}
