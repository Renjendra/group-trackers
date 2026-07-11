import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/group_model.dart';
import '../models/member_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get groups => _firestore.collection('groups');

  CollectionReference get users => _firestore.collection('users');

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
      groupRef.collection('members').doc(owner.uid),
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
      snapshot.data() as Map<String, dynamic>,
    );
  }

  // ==========================
  // JOIN GROUP
  // ==========================

  Future<void> joinGroup(
    GroupModel group,
    MemberModel member,
  ) async {
    final memberRef = groups
        .doc(group.id)
        .collection('members')
        .doc(member.uid);

    // Jangan menambah member jika sudah bergabung
    if ((await memberRef.get()).exists) {
      return;
    }

    final batch = _firestore.batch();

    batch.set(
      memberRef,
      member.toMap(),
    );

    batch.update(
      groups.doc(group.id),
      {
        'members': FieldValue.increment(1),
      },
    );

    await batch.commit();
  }

  // ==========================
  // GET GROUPS
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
    await groups.doc(group.id).update(group.toMap());
  }

  // ==========================
  // DELETE GROUP
  // ==========================

  Future<void> deleteGroup(String id) async {
    await groups.doc(id).delete();
  }
// ==========================
// CREATE USER
// ==========================

Future<void> createUser(
  UserModel user,
) async {
  await users.doc(user.uid).set(
    user.toMap(),
  );
}

// ==========================
// GET USER
// ==========================

Future<UserModel?> getUser(
  String uid,
) async {
  final snapshot = await users.doc(uid).get();

  if (!snapshot.exists) {
    return null;
  }

  return UserModel.fromMap(
    snapshot.id,
    snapshot.data() as Map<String, dynamic>,
  );
}

// ==========================
// GET USER GROUPS
// ==========================

Stream<List<GroupModel>> getUserGroups(
  String uid,
) {
  return groups.snapshots().asyncMap((snapshot) async {
    List<GroupModel> result = [];

    for (final doc in snapshot.docs) {
      final member = await doc.reference
          .collection('members')
          .doc(uid)
          .get();

      if (member.exists) {
        result.add(
          GroupModel.fromMap(
            doc.id,
            doc.data() as Map<String, dynamic>,
          ),
        );
      }
    }

    return result;
  });
}


Future<void> resetMember(
  String groupId,
  String uid,
) async {
  await groups
      .doc(groupId)
      .collection('members')
      .doc(uid)
      .update({
    'lastResetAt': Timestamp.now(),
  });
}

Future<void> leaveGroup(
  String groupId,
  String uid,
) async {
  final batch = _firestore.batch();

  final groupRef = groups.doc(groupId);

  batch.delete(
    groupRef
        .collection('members')
        .doc(uid),
  );

  batch.update(
    groupRef,
    {
      'members': FieldValue.increment(-1),
    },
  );

  await batch.commit();
}

// ==========================
// GET MEMBERS
// ==========================

Stream<List<MemberModel>> getMembers(
  String groupId,
) {
  return groups
      .doc(groupId)
      .collection('members')
      .snapshots()
      .map((snapshot) {

    final members = snapshot.docs.map((doc) {
      return MemberModel.fromMap(
        doc.id,
        doc.data(),
      );
    }).toList();

    members.sort(
      (a, b) =>
          b.streakDays.compareTo(a.streakDays),
    );

    return members;
  });
}

}