import 'package:allyoucaneattogether/models/group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('groups');

  Future<Group> create() async {
    return await collection
        .add(Group().toJson())
        .then((ref) => ref.get())
        .then((doc) => Group.fromSnapshot(doc));
  }

  void update(Group group) async {
    await collection.doc(group.uid).update(group.toJson());
  }

  void delete(Group group) async {
    await collection.doc(group.uid).delete();
  }

  Future<Group?> getGroupByCode(String code) async {
    return await collection
        .where('code', isEqualTo: code)
        .limit(1)
        .get()
        .then((query) {
      if (query.docs.isEmpty) return null;
      return Group.fromSnapshot(query.docs.first);
    });
  }

  Stream<Group?> getGroupStream(Group group) {
    return collection
        .doc(group.uid)
        .snapshots()
        .map((snapshot) => Group.fromSnapshot(snapshot));
  }
}
