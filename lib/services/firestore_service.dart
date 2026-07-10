import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/group_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference groups =
      FirebaseFirestore.instance.collection('groups');

  Future<void> createGroup(GroupModel group) async {
    await groups.doc(group.id).set(group.toMap());
  }

  Stream<List<GroupModel>> getGroups() {
    return groups.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return GroupModel.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  Future<void> updateGroup(GroupModel group) async {
    await groups.doc(group.id).update(group.toMap());
  }

  Future<void> deleteGroup(String id) async {
    await groups.doc(id).delete();
  }
}