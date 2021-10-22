import 'package:gosushi/models/group.dart';
import 'package:gosushi/models/order.dart';
import 'package:gosushi/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersRepository {
  final CollectionReference _collection;

  OrdersRepository(Group group)
      : _collection = FirebaseFirestore.instance
            .collection('groups')
            .doc(group.uid)
            .collection('orders');

  Future<List<Order>> findUserOrders(User user) {
    return _collection
        .where('user.uid', isEqualTo: user.uid)
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
      List<Order> orders = [];
      for (var document in snapshot.docs) {
        if (document.exists) orders.add(Order.fromSnapshot(document));
      }
      return orders;
    });
  }
}
