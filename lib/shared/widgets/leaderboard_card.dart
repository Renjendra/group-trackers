import 'package:flutter/material.dart';
import '../../models/member_model.dart';

class LeaderboardCard extends StatelessWidget {
  final List<MemberModel> members;
  final String? currentUid; // pass FirebaseAuth.instance.currentUser?.uid

  const LeaderboardCard({
    super.key,
    required this.members,
    this.currentUid,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Leaderboard",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            if (members.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "Belum ada data",
                  style: TextStyle(color: Colors.white38, fontSize: 14),
                ),
              )
            else
              _LeaderboardBody(members: members, currentUid: currentUid),
          ],
        ),
      ),
    );
  }
}

class _LeaderboardBody extends StatelessWidget {
  final List<MemberModel> members;
  final String? currentUid;

  const _LeaderboardBody({required this.members, required this.currentUid});

  @override
  Widget build(BuildContext context) {
    final top3 = members.take(3).toList();
    final rest = members.length > 3 ? members.sublist(3) : <MemberModel>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (top3.isNotEmpty) _Podium(top3: top3),
        if (rest.isNotEmpty) ...[
          const SizedBox(height: 20),
          _LeaderboardList(
            members: rest,
            startRank: 4,
            currentUid: currentUid,
          ),
        ],
      ],
    );
  }
}

// ---------------- Podium ----------------

class _Podium extends StatelessWidget {
  final List<MemberModel> top3;

  const _Podium({required this.top3});

  @override
  Widget build(BuildContext context) {
    final ordered = <int>[];
    if (top3.length > 1) ordered.add(1);
    ordered.add(0);
    if (top3.length > 2) ordered.add(2);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: ordered
          .map((i) => Expanded(child: _PodiumSlot(member: top3[i], rank: i)))
          .toList(),
    );
  }
}

class _PodiumSlot extends StatelessWidget {
  final MemberModel member;
  final int rank; // 0, 1, 2

  const _PodiumSlot({required this.member, required this.rank});

  bool get isFirst => rank == 0;

  double get _barHeight {
    switch (rank) {
      case 0:
        return 64;
      case 1:
        return 44;
      default:
        return 32;
    }
  }

  Color get _accentBg =>
      isFirst ? const Color(0xFF3A2E14) : const Color(0xFF37414F);

  Color get _accentText =>
      isFirst ? const Color(0xFFFAC775) : const Color(0xFFD3D6DB);

  Color get _borderColor =>
      isFirst ? const Color(0xFFFAC775) : const Color(0xFF5B6674);

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isFirst ? 56 : 48,
          height: isFirst ? 56 : 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _accentBg,
            shape: BoxShape.circle,
            border: Border.all(color: _borderColor, width: 1.5),
          ),
          child: Text(
            _initials(member.username),
            style: TextStyle(
              color: _accentText,
              fontSize: isFirst ? 15 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          member.username,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isFirst ? 14 : 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_fire_department_rounded,
                size: isFirst ? 14 : 13,
                color: isFirst ? _accentText : Colors.white70),
            const SizedBox(width: 3),
            Text(
              "${member.streakDays}",
              style: TextStyle(
                fontSize: isFirst ? 13 : 12,
                fontWeight: FontWeight.w600,
                color: isFirst ? _accentText : Colors.white70,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: _barHeight,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: _accentBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: isFirst
                ? null
                : Border.all(color: _borderColor.withOpacity(0.4), width: 1),
          ),
          alignment: Alignment.center,
          child: Text(
            "${rank + 1}",
            style: TextStyle(
              fontSize: isFirst ? 14 : 13,
              fontWeight: FontWeight.w600,
              color: _accentText,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------- List (rank 4+) ----------------

class _LeaderboardList extends StatelessWidget {
  final List<MemberModel> members;
  final int startRank;
  final String? currentUid;

  const _LeaderboardList({
    required this.members,
    required this.startRank,
    this.currentUid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C2431),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        children: List.generate(members.length, (i) {
          final member = members[i];
          final rank = startRank + i;
          final isCurrent = currentUid != null && member.uid == currentUid;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                top: i == 0
                    ? BorderSide.none
                    : BorderSide(color: Colors.white.withOpacity(0.06)),
                left: isCurrent
                    ? const BorderSide(color: Color(0xFF378ADD), width: 2)
                    : BorderSide.none,
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  child: Text(
                    "$rank",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, color: Colors.white38),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? const Color(0xFF185FA5)
                        : Colors.white.withOpacity(0.06),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    _initials(member.username),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isCurrent ? Colors.white : Colors.white70,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isCurrent ? "${member.username} (kamu)" : member.username,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 28,
                  child: Text(
                    "${member.streakDays}",
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.local_fire_department_rounded,
                  size: 14,
                  color: Colors.white38,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}