class DifficultyStats {
  int gamesPlayed;
  int gamesWon;
  Duration bestTime;
  Duration totalPlayTime;
  int hintsUsed;

  DifficultyStats({
    this.gamesPlayed = 0,
    this.gamesWon = 0,
    this.bestTime = const Duration(hours: 99),
    this.totalPlayTime = Duration.zero,
    this.hintsUsed = 0,
  });

  double get winRate => gamesPlayed == 0 ? 0 : (gamesWon / gamesPlayed) * 100;
  
  Duration get averageTime => gamesPlayed == 0 
      ? Duration.zero 
      : Duration(seconds: totalPlayTime.inSeconds ~/ gamesPlayed);

  Map<String, dynamic> toJson() => {
    'gamesPlayed': gamesPlayed,
    'gamesWon': gamesWon,
    'bestTime': bestTime.inSeconds,
    'totalPlayTime': totalPlayTime.inSeconds,
    'hintsUsed': hintsUsed,
  };

  factory DifficultyStats.fromJson(Map<String, dynamic> json) {
    return DifficultyStats(
      gamesPlayed: json['gamesPlayed'] ?? 0,
      gamesWon: json['gamesWon'] ?? 0,
      bestTime: Duration(seconds: json['bestTime'] ?? 356400),
      totalPlayTime: Duration(seconds: json['totalPlayTime'] ?? 0),
      hintsUsed: json['hintsUsed'] ?? 0,
    );
  }
}

class GameStatistics {
  Map<String, DifficultyStats> difficultyStats;
  DateTime lastPlayed;
  int currentStreak;
  int bestStreak;
  int totalGamesPlayed;

  GameStatistics({
    Map<String, DifficultyStats>? difficultyStats,
    DateTime? lastPlayed,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.totalGamesPlayed = 0,
  }) : difficultyStats = difficultyStats ?? {
          'easy': DifficultyStats(),
          'medium': DifficultyStats(),
          'hard': DifficultyStats(),
          'expert': DifficultyStats(),
        },
        lastPlayed = lastPlayed ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'difficultyStats': difficultyStats.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    'lastPlayed': lastPlayed.toIso8601String(),
    'currentStreak': currentStreak,
    'bestStreak': bestStreak,
    'totalGamesPlayed': totalGamesPlayed,
  };

  factory GameStatistics.fromJson(Map<String, dynamic> json) {
    final diffStats = (json['difficultyStats'] as Map<String, dynamic>?)?.map(
      (key, value) => MapEntry(
        key,
        DifficultyStats.fromJson(value as Map<String, dynamic>),
      ),
    );

    return GameStatistics(
      difficultyStats: diffStats,
      lastPlayed: DateTime.tryParse(json['lastPlayed'] ?? ''),
      currentStreak: json['currentStreak'] ?? 0,
      bestStreak: json['bestStreak'] ?? 0,
      totalGamesPlayed: json['totalGamesPlayed'] ?? 0,
    );
  }
}
