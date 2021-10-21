import 'package:allyoucaneattogether/models/group.dart';
import 'package:allyoucaneattogether/models/order.dart';
import 'package:allyoucaneattogether/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersRepository {
  final CollectionReference _collection;

  OrdersRepository(Group group)
      : _collection = FirebaseFirestore.instance
            .collection('groups')
            .doc(group.uid)
            .collection('orders');

  Future<List<Order>> getOrdersByUser(User user) {
    return _collection
        .where('user', isEqualTo: user.uid)
        .get()
        .then((query) => query.docs.map((e) => Order.fromSnapshot(e)).toList());
  }

  Future<Order> add(Order order) {
    Map<String, dynamic> jsonOrder = order.toJson();
    jsonOrder.addAll({'timestamp': FieldValue.serverTimestamp()});
    return _collection
        .add(jsonOrder)
        .then((ref) => ref.get())
        .then((doc) => Order.fromSnapshot(doc));
  }

  Future<void> update(Order order) {
    return _collection.doc(order.uid).update(order.toJson());
  }

  Future<void> delete(Order order) {
    return _collection.doc(order.uid).delete();
  }

  Stream<List<Order>> get orders {
    return _collection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) => Order.fromSnapshot(doc)).toList();
    });
  }
}
