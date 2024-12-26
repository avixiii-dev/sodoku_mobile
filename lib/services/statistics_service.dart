import 'dart:convert';
import 'package:shared_preferences.dart';
import '../models/statistics.dart';

class StatisticsService {
  static const String _statsKey = 'sudoku_statistics';
  final SharedPreferences _prefs;
  late GameStatistics statistics;

  StatisticsService(this._prefs) {
    _loadStatistics();
  }

  void _loadStatistics() {
    final statsJson = _prefs.getString(_statsKey);
    if (statsJson != null) {
      try {
        statistics = GameStatistics.fromJson(json.decode(statsJson));
      } catch (e) {
        statistics = GameStatistics();
      }
    } else {
      statistics = GameStatistics();
    }
  }

  Future<void> saveStatistics() async {
    await _prefs.setString(_statsKey, json.encode(statistics.toJson()));
  }

  void recordGamePlayed({
    required String difficulty,
    required bool won,
    required Duration playTime,
    required int hintsUsed,
  }) {
    final stats = statistics.difficultyStats[difficulty]!;
    stats.gamesPlayed++;
    statistics.totalGamesPlayed++;

    if (won) {
      stats.gamesWon++;
      if (playTime < stats.bestTime) {
        stats.bestTime = playTime;
      }
      _updateStreak(true);
    } else {
      _updateStreak(false);
    }

    stats.totalPlayTime += playTime;
    stats.hintsUsed += hintsUsed;
    statistics.lastPlayed = DateTime.now();

    saveStatistics();
  }

  void _updateStreak(bool won) {
    if (won) {
      statistics.currentStreak++;
      if (statistics.currentStreak > statistics.bestStreak) {
        statistics.bestStreak = statistics.currentStreak;
      }
    } else {
      statistics.currentStreak = 0;
    }
  }

  String formatDuration(Duration duration) {
    if (duration == const Duration(hours: 99)) {
      return '--:--';
    }
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Map<String, String> getDifficultyStats(String difficulty) {
    final stats = statistics.difficultyStats[difficulty]!;
    return {
      'Games Played': stats.gamesPlayed.toString(),
      'Win Rate': '${stats.winRate.toStringAsFixed(1)}%',
      'Best Time': formatDuration(stats.bestTime),
      'Average Time': formatDuration(stats.averageTime),
      'Hints Used': stats.hintsUsed.toString(),
    };
  }

  Map<String, String> getOverallStats() {
    return {
      'Total Games': statistics.totalGamesPlayed.toString(),
      'Current Streak': statistics.currentStreak.toString(),
      'Best Streak': statistics.bestStreak.toString(),
      'Last Played': _formatLastPlayed(),
    };
  }

  String _formatLastPlayed() {
    final now = DateTime.now();
    final difference = now.difference(statistics.lastPlayed);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
