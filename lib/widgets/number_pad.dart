import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_state.dart';

class NumberPad extends StatelessWidget {
  const NumberPad({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                _buildActionButton(
                  context,
                  icon: Consumer<GameState>(
                    builder: (context, gameState, child) {
                      return Icon(
                        gameState.isNotesMode
                            ? Icons.edit
                            : Icons.edit_outlined,
                        color: gameState.isNotesMode
                            ? Theme.of(context).primaryColor
                            : null,
                      );
                    },
                  ),
                  onPressed: () {
                    context.read<GameState>().toggleNotesMode();
                  },
                ),
                _buildActionButton(
                  context,
                  icon: const Icon(Icons.lightbulb_outline),
                  onPressed: () {
                    context.read<GameState>().useHint();
                  },
                ),
                _buildActionButton(
                  context,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    context.read<GameState>().clearSelectedCell();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return _buildNumberButton(context, index + 1);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required Widget icon,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: icon,
        ),
      ),
    );
  }

  Widget _buildNumberButton(BuildContext context, int number) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        final isNoteActive = gameState.isNotesMode &&
            gameState.selectedRow != null &&
            gameState.selectedCol != null &&
            gameState.board.cells[gameState.selectedRow!][gameState.selectedCol!]
                .notes
                .contains(number);

        return ElevatedButton(
          onPressed: () {
            gameState.inputNumber(number);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isNoteActive
                ? Theme.of(context).primaryColor.withOpacity(0.2)
                : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            number.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isNoteActive
                  ? Theme.of(context).primaryColor
                  : null,
            ),
          ),
        );
      },
    );
  }
}
