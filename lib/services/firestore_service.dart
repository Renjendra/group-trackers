import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/group_model.dart';
import '../models/member_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get groups =>
      _firestore.collection('groups');

  Future<void> createGroup(
    GroupModel group,
    MemberModel owner,
  ) async {
    final batch = _firestore.batch();

    final groupRef = groups.doc(group.id);

    batch.set(
      groupRef,
      group.toMap(),
    );

    batch.set(
      groupRef
          .collection('members')
          .doc(owner.uid),
      owner.toMap(),
    );

    await batch.commit();
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