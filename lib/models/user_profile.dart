class UserProfile {
  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl;
  final int totalScore;
  final Map<String, int> highScores;
  final int rank;
  final List<String> achievements;

  UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
    this.totalScore = 0,
    Map<String, int>? highScores,
    this.rank = 0,
    List<String>? achievements,
  }) : highScores = highScores ?? {
          'easy': 0,
          'medium': 0,
          'hard': 0,
          'expert': 0,
        },
        achievements = achievements ?? [];

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'displayName': displayName,
        'email': email,
        'photoUrl': photoUrl,
        'totalScore': totalScore,
        'highScores': highScores,
        'rank': rank,
        'achievements': achievements,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
      totalScore: json['totalScore'] as int? ?? 0,
      highScores: Map<String, int>.from(json['highScores'] as Map? ?? {}),
      rank: json['rank'] as int? ?? 0,
      achievements: List<String>.from(json['achievements'] as List? ?? []),
    );
  }

  UserProfile copyWith({
    String? displayName,
    String? email,
    String? photoUrl,
    int? totalScore,
    Map<String, int>? highScores,
    int? rank,
    List<String>? achievements,
  }) {
    return UserProfile(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      totalScore: totalScore ?? this.totalScore,
      highScores: highScores ?? Map<String, int>.from(this.highScores),
      rank: rank ?? this.rank,
      achievements: achievements ?? List<String>.from(this.achievements),
    );
  }
}
