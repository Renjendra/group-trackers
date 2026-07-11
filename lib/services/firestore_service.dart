import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/group_model.dart';
import '../models/member_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get groups =>
      _firestore.collection('groups');

  // ==========================
  // CREATE GROUP
  // ==========================

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

  // ==========================
  // FIND GROUP BY INVITE CODE
  // ==========================

  Future<GroupModel?> findGroupByCode(String code) async {
    final snapshot = await groups
        .where(
          'code',
          isEqualTo: code.trim().toUpperCase(),
        )
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final doc = snapshot.docs.first;

    return GroupModel.fromMap(
      doc.id,
      doc.data() as Map<String, dynamic>,
    );
  }

  // ==========================
  // GET OWNER
  // ==========================

  Future<MemberModel?> getOwner(
    GroupModel group,
  ) async {
    final snapshot = await groups
        .doc(group.id)
        .collection('members')
        .doc(group.ownerId)
        .get();

    if (!snapshot.exists) {
      return null;
    }

    return MemberModel.fromMap(
      snapshot.id,
      snapshot.data()!,
    );
  }

  // ==========================
  // JOIN GROUP
  // ==========================

  Future<void> joinGroup(
    GroupModel group,
    MemberModel member,
  ) async {
    final batch = _firestore.batch();

    final groupRef = groups.doc(group.id);

    batch.set(
      groupRef
          .collection('members')
          .doc(member.uid),
      member.toMap(),
    );

    batch.update(groupRef, {
      'members': FieldValue.increment(1),
    });

    await batch.commit();
  }

  // ==========================
  // GET ALL GROUPS
  // ==========================

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

  // ==========================
  // UPDATE GROUP
  // ==========================

  Future<void> updateGroup(
    GroupModel group,
  ) async {
    await groups
        .doc(group.id)
        .update(group.toMap());
  }

  // ==========================
  // DELETE GROUP
  // ==========================

  Future<void> deleteGroup(
    String id,
  ) async {
    await groups
        .doc(id)
        .delete();
  }
}