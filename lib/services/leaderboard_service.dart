import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardEntry {
  final String uid;
  final String displayName;
  final int score;
  final int time;
  final DateTime timestamp;

  LeaderboardEntry({
    required this.uid,
    required this.displayName,
    required this.score,
    required this.time,
    required this.timestamp,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String,
      score: json['score'] as int,
      time: json['time'] as int,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }
}

class LeaderboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<LeaderboardEntry>> getLeaderboard(String difficulty) {
    return _firestore
        .collection('leaderboards')
        .doc(difficulty)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return [];

      final List<dynamic> scores = snapshot.data()?['scores'] ?? [];
      return scores
          .map((score) => LeaderboardEntry.fromJson(score))
          .toList()
        ..sort((a, b) {
          final scoreCompare = b.score.compareTo(a.score);
          if (scoreCompare != 0) return scoreCompare;
          return a.time.compareTo(b.time);
        });
    });
  }

  Stream<List<LeaderboardEntry>> getGlobalLeaderboard() {
    return _firestore
        .collection('users')
        .orderBy('totalScore', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return LeaderboardEntry(
          uid: doc.id,
          displayName: data['displayName'],
          score: data['totalScore'] ?? 0,
          time: 0,
          timestamp: DateTime.now(),
        );
      }).toList();
    });
  }

  Future<int> getUserRank(String uid, String difficulty) async {
    final leaderboard = await getLeaderboard(difficulty).first;
    final index = leaderboard.indexWhere((entry) => entry.uid == uid);
    return index == -1 ? -1 : index + 1;
  }

  Future<int> getGlobalUserRank(String uid) async {
    final leaderboard = await getGlobalLeaderboard().first;
    final index = leaderboard.indexWhere((entry) => entry.uid == uid);
    return index == -1 ? -1 : index + 1;
  }
}
