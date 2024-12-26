import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/sudoku_board.dart';
import '../services/game_state.dart';
import 'animated_cell.dart';

class SudokuGrid extends StatefulWidget {
  final SudokuBoard board;

  const SudokuGrid({super.key, required this.board});

  @override
  State<SudokuGrid> createState() => _SudokuGridState();
}

class _SudokuGridState extends State<SudokuGrid> {
  int? selectedRow;
  int? selectedCol;

  void _selectCell(int row, int col) {
    setState(() {
      if (selectedRow == row && selectedCol == col) {
        // Deselect if tapping the same cell
        selectedRow = null;
        selectedCol = null;
      } else {
        selectedRow = row;
        selectedCol = col;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 9,
          ),
          itemCount: 81,
          itemBuilder: (context, index) {
            final row = index ~/ 9;
            final col = index % 9;
            final cell = widget.board.cells[row][col];

            return AnimatedSudokuCell(
              cell: cell,
              isSelected: row == selectedRow && col == selectedCol,
              onTap: () => _selectCell(row, col),
              row: row,
              col: col,
            );
          },
        ),
      ),
    );
  }
}
