import 'package:flutter/material.dart';
import '../models/sudoku_cell.dart';

class AnimatedSudokuCell extends StatefulWidget {
  final SudokuCell cell;
  final bool isSelected;
  final VoidCallback onTap;
  final int row;
  final int col;

  const AnimatedSudokuCell({
    super.key,
    required this.cell,
    required this.isSelected,
    required this.onTap,
    required this.row,
    required this.col,
  });

  @override
  State<AnimatedSudokuCell> createState() => _AnimatedSudokuCellState();
}

class _AnimatedSudokuCellState extends State<AnimatedSudokuCell>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedSudokuCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cell.value != oldWidget.cell.value) {
      _controller.forward(from: 0.0);
    }
  }

  Color _getCellColor() {
    if (widget.isSelected) {
      return Colors.blue.withOpacity(0.3);
    } else if (!widget.cell.isValid) {
      return Colors.red.withOpacity(0.2);
    } else if (widget.cell.isInitial) {
      return Colors.grey.withOpacity(0.2);
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward(from: 0.0);
        widget.onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _getCellColor(),
          border: Border(
            right: BorderSide(
              width: (widget.col + 1) % 3 == 0 ? 2.0 : 1.0,
              color: Colors.black,
            ),
            bottom: BorderSide(
              width: (widget.row + 1) % 3 == 0 ? 2.0 : 1.0,
              color: Colors.black,
            ),
          ),
        ),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Center(
            child: widget.cell.value != null
                ? FadeTransition(
                    opacity: _opacityAnimation,
                    child: Text(
                      widget.cell.value.toString(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: widget.cell.isInitial
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: widget.cell.isInitial ? Colors.black : Colors.blue,
                      ),
                    ),
                  )
                : widget.cell.notes.isNotEmpty
                    ? _buildNotes()
                    : null,
          ),
        ),
      ),
    );
  }

  Widget _buildNotes() {
    return GridView.count(
      crossAxisCount: 3,
      padding: const EdgeInsets.all(2),
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(9, (index) {
        final number = index + 1;
        return Center(
          child: widget.cell.notes.contains(number)
              ? FadeTransition(
                  opacity: _opacityAnimation,
                  child: Text(
                    number.toString(),
                    style: const TextStyle(
                      fontSize: 8,
                      color: Colors.grey,
                    ),
                  ),
                )
              : null,
        );
      }),
    );
  }
}
