import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sudoku_board.dart';
import '../models/sudoku_cell.dart';
import 'statistics_service.dart';
import 'auth_service.dart';
import 'dart:async';

class GameState extends ChangeNotifier {
  late SudokuBoard board;
  String difficulty = 'easy';
  int hintsRemaining = 3;
  Duration playTime = Duration.zero;
  bool isPaused = false;
  bool isSoundEnabled = true;
  bool isNotesMode = false;
  int? selectedRow;
  int? selectedCol;
  Timer? _timer;
  final StatisticsService statisticsService;
  final AuthService authService;
  int hintsUsed = 0;

  GameState(SharedPreferences prefs, {required this.authService}) : 
    statisticsService = StatisticsService(prefs) {
    board = SudokuBoard();
    startNewGame();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused) {
        playTime += const Duration(seconds: 1);
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startNewGame() {
    board.generatePuzzle(difficulty);
    hintsRemaining = 3;
    playTime = Duration.zero;
    isPaused = false;
    selectedRow = null;
    selectedCol = null;
    hintsUsed = 0;
    _startTimer();
    notifyListeners();
  }

  void setDifficulty(String newDifficulty) {
    difficulty = newDifficulty;
    startNewGame();
  }

  void selectCell(int row, int col) {
    if (selectedRow == row && selectedCol == col) {
      selectedRow = null;
      selectedCol = null;
    } else {
      selectedRow = row;
      selectedCol = col;
    }
    notifyListeners();
  }

  void inputNumber(int number) {
    if (selectedRow != null && selectedCol != null) {
      final cell = board.cells[selectedRow!][selectedCol!];
      if (!cell.isInitial) {
        if (isNotesMode) {
          toggleNote(selectedRow!, selectedCol!, number);
        } else {
          updateCell(selectedRow!, selectedCol!, number);
          if (checkWin()) {
            _handleGameWon();
          }
        }
      }
    }
  }

  void updateCell(int row, int col, int? value) {
    if (!board.cells[row][col].isInitial) {
      board.cells[row][col].value = value;
      board.cells[row][col].isValid = value == null || board.isValidMove(row, col, value);
      board.cells[row][col].notes.clear();
      notifyListeners();
    }
  }

  void toggleNote(int row, int col, int number) {
    if (!board.cells[row][col].isInitial && board.cells[row][col].value == null) {
      var notes = board.cells[row][col].notes;
      if (notes.contains(number)) {
        notes.remove(number);
      } else {
        notes.add(number);
      }
      notifyListeners();
    }
  }

  void toggleNotesMode() {
    isNotesMode = !isNotesMode;
    notifyListeners();
  }

  void clearSelectedCell() {
    if (selectedRow != null && selectedCol != null) {
      updateCell(selectedRow!, selectedCol!, null);
    }
  }

  void useHint() {
    if (hintsRemaining > 0 && selectedRow != null && selectedCol != null) {
      final cell = board.cells[selectedRow!][selectedCol!];
      if (!cell.isInitial && (cell.value == null || !cell.isValid)) {
        hintsRemaining--;
        hintsUsed++;
        // TODO: Implement hint logic to find correct value
        notifyListeners();
      }
    }
  }

  void togglePause() {
    isPaused = !isPaused;
    notifyListeners();
  }

  void toggleSound() {
    isSoundEnabled = !isSoundEnabled;
    notifyListeners();
  }

  bool checkWin() {
    return board.isBoardComplete();
  }

  void _handleGameWon() {
    _timer?.cancel();
    
    // Update local statistics
    statisticsService.recordGamePlayed(
      difficulty: difficulty,
      won: true,
      playTime: playTime,
      hintsUsed: hintsUsed,
    );

    // Update online statistics if user is logged in
    if (authService.isAuthenticated) {
      final score = _calculateScore();
      authService.updateGameStats(
        difficulty: difficulty,
        score: score,
        time: playTime,
      );
    }

    notifyListeners();
  }

  int _calculateScore() {
    // Base score depends on difficulty
    final difficultyMultiplier = {
      'easy': 1,
      'medium': 2,
      'hard': 3,
      'expert': 4,
    }[difficulty] ?? 1;

    // Base score (1000 points)
    int score = 1000 * difficultyMultiplier;

    // Deduct points for time taken (10 points per minute)
    final minutesTaken = playTime.inMinutes;
    score -= minutesTaken * 10;

    // Deduct points for hints used (100 points per hint)
    score -= hintsUsed * 100;

    // Ensure minimum score of 100
    return score.clamp(100, 10000);
  }

  String formatTime() {
    final minutes = playTime.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = playTime.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
