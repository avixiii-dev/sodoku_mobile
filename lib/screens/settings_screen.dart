import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Difficulty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Consumer<GameState>(
            builder: (context, gameState, child) {
              return Column(
                children: [
                  _buildDifficultyTile(
                    context: context,
                    title: 'Easy',
                    subtitle: '35 numbers filled',
                    isSelected: gameState.difficulty == 'easy',
                    onTap: () => _changeDifficulty(context, 'easy'),
                  ),
                  _buildDifficultyTile(
                    context: context,
                    title: 'Medium',
                    subtitle: '30 numbers filled',
                    isSelected: gameState.difficulty == 'medium',
                    onTap: () => _changeDifficulty(context, 'medium'),
                  ),
                  _buildDifficultyTile(
                    context: context,
                    title: 'Hard',
                    subtitle: '25 numbers filled',
                    isSelected: gameState.difficulty == 'hard',
                    onTap: () => _changeDifficulty(context, 'hard'),
                  ),
                  _buildDifficultyTile(
                    context: context,
                    title: 'Expert',
                    subtitle: '20 numbers filled',
                    isSelected: gameState.difficulty == 'expert',
                    onTap: () => _changeDifficulty(context, 'expert'),
                  ),
                ],
              );
            },
          ),
          const Divider(),
          Consumer<GameState>(
            builder: (context, gameState, child) {
              return SwitchListTile(
                title: const Text('Sound'),
                subtitle: const Text('Enable or disable game sounds'),
                value: gameState.isSoundEnabled,
                onChanged: (bool value) {
                  gameState.toggleSound();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
      onTap: onTap,
      tileColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
    );
  }

  void _changeDifficulty(BuildContext context, String difficulty) {
    final gameState = context.read<GameState>();
    gameState.setDifficulty(difficulty);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Difficulty changed to $difficulty'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'New Game',
          onPressed: () {
            gameState.startNewGame();
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
