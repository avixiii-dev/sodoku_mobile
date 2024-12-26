import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_state.dart';
import '../widgets/sudoku_grid.dart';
import '../widgets/number_pad.dart';
import 'settings_screen.dart';
import 'statistics_screen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatisticsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<GameState>().startNewGame();
            },
          ),
          IconButton(
            icon: Consumer<GameState>(
              builder: (context, gameState, child) {
                return Icon(
                  gameState.isSoundEnabled ? Icons.volume_up : Icons.volume_off,
                );
              },
            ),
            onPressed: () {
              context.read<GameState>().toggleSound();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Consumer<GameState>(
            builder: (context, gameState, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Difficulty: ${gameState.difficulty.toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Time: ${gameState.formatTime()}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<GameState>(
                builder: (context, gameState, child) {
                  return SudokuGrid(board: gameState.board);
                },
              ),
            ),
          ),
          const Expanded(
            flex: 3,
            child: NumberPad(),
          ),
        ],
      ),
    );
  }
}
