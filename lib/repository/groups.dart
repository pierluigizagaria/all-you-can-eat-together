import 'package:allyoucaneattogether/models/group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('groups');

  Future<Group> create() {
    return _collection
        .add(Group().toJson())
        .then((ref) => ref.get())
        .then((doc) => Group.fromSnapshot(doc));
  }

  Future<void> update(Group group) {
    return _collection.doc(group.uid).update(group.toJson());
  }

  Future<void> delete(Group group) {
    return _collection.doc(group.uid).delete();
  }

  Future<Group?> findGroup(String code) {
    return _collection
        .where('code', isEqualTo: code)
        .limit(1)
        .get()
        .then((query) {
      if (query.docs.isEmpty) return null;
      return Group.fromSnapshot(query.docs.first);
    });
  }

  Stream<Group?> stream(Group group) {
    return _collection
        .doc(group.uid)
        .snapshots()
        .map((snapshot) => Group.fromSnapshot(snapshot));
  }
}
