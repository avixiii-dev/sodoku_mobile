import 'dart:math';
import 'sudoku_cell.dart';

class SudokuBoard {
  late List<List<SudokuCell>> cells;
  final int size = 9;
  final Random _random = Random();

  SudokuBoard() {
    cells = List.generate(
      size,
      (i) => List.generate(
        size,
        (j) => SudokuCell(),
      ),
    );
  }

  bool isValidMove(int row, int col, int value) {
    // Check row
    for (int i = 0; i < size; i++) {
      if (i != col && cells[row][i].value == value) return false;
    }

    // Check column
    for (int i = 0; i < size; i++) {
      if (i != row && cells[i][col].value == value) return false;
    }

    // Check 3x3 box
    int boxRow = (row ~/ 3) * 3;
    int boxCol = (col ~/ 3) * 3;
    for (int i = boxRow; i < boxRow + 3; i++) {
      for (int j = boxCol; j < boxCol + 3; j++) {
        if (i != row && j != col && cells[i][j].value == value) return false;
      }
    }

    return true;
  }

  void generatePuzzle(String difficulty) {
    // Clear the board
    cells = List.generate(
      size,
      (i) => List.generate(
        size,
        (j) => SudokuCell(),
      ),
    );

    // Generate a solved board
    _generateSolvedBoard(0, 0);

    // Remove numbers based on difficulty
    int cellsToRemove;
    switch (difficulty) {
      case 'easy':
        cellsToRemove = 46; // 35 cells filled
        break;
      case 'medium':
        cellsToRemove = 51; // 30 cells filled
        break;
      case 'hard':
        cellsToRemove = 56; // 25 cells filled
        break;
      case 'expert':
        cellsToRemove = 61; // 20 cells filled
        break;
      default:
        cellsToRemove = 46;
    }

    _removeNumbers(cellsToRemove);
  }

  bool _generateSolvedBoard(int row, int col) {
    if (col == size) {
      row++;
      col = 0;
    }
    if (row == size) return true;

    if (cells[row][col].value != null) {
      return _generateSolvedBoard(row, col + 1);
    }

    List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    numbers.shuffle(_random);

    for (int num in numbers) {
      if (isValidMove(row, col, num)) {
        cells[row][col].value = num;
        cells[row][col].isInitial = true;
        
        if (_generateSolvedBoard(row, col + 1)) {
          return true;
        }
        
        cells[row][col].value = null;
        cells[row][col].isInitial = false;
      }
    }

    return false;
  }

  void _removeNumbers(int count) {
    List<int> positions = List.generate(81, (index) => index);
    positions.shuffle(_random);

    for (int i = 0; i < count; i++) {
      int pos = positions[i];
      int row = pos ~/ 9;
      int col = pos % 9;
      cells[row][col].value = null;
      cells[row][col].isInitial = false;
    }
  }

  bool isBoardComplete() {
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (cells[i][j].value == null || !cells[i][j].isValid) {
          return false;
        }
      }
    }
    return true;
  }
}
