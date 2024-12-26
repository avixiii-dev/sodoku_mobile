import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/leaderboard_service.dart';
import 'auth/login_screen.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final LeaderboardService _leaderboardService = LeaderboardService();
  String _selectedDifficulty = 'easy';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildLeaderboardEntry(LeaderboardEntry entry, int index) {
    final isCurrentUser = context.read<AuthService>().userProfile?.uid == entry.uid;
    final medal = index < 3 ? ['🥇', '🥈', '🥉'][index] : '${index + 1}.';

    return Card(
      color: isCurrentUser ? Colors.blue.withOpacity(0.1) : null,
      child: ListTile(
        leading: Text(
          medal,
          style: const TextStyle(fontSize: 20),
        ),
        title: Text(
          entry.displayName,
          style: TextStyle(
            fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Score: ${entry.score}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (entry.time > 0)
              Text(
                'Time: ${Duration(seconds: entry.time).toString().split('.').first}',
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyLeaderboard() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'easy', label: Text('Easy')),
              ButtonSegment(value: 'medium', label: Text('Medium')),
              ButtonSegment(value: 'hard', label: Text('Hard')),
              ButtonSegment(value: 'expert', label: Text('Expert')),
            ],
            selected: {_selectedDifficulty},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                _selectedDifficulty = newSelection.first;
              });
            },
          ),
        ),
        Expanded(
          child: StreamBuilder<List<LeaderboardEntry>>(
            stream: _leaderboardService.getLeaderboard(_selectedDifficulty),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final entries = snapshot.data!;
              if (entries.isEmpty) {
                return const Center(
                  child: Text('No scores yet. Be the first to play!'),
                );
              }

              return ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) =>
                    _buildLeaderboardEntry(entries[index], index),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGlobalLeaderboard() {
    return StreamBuilder<List<LeaderboardEntry>>(
      stream: _leaderboardService.getGlobalLeaderboard(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final entries = snapshot.data!;
        if (entries.isEmpty) {
          return const Center(
            child: Text('No global rankings yet. Start playing to rank up!'),
          );
        }

        return ListView.builder(
          itemCount: entries.length,
          itemBuilder: (context, index) =>
              _buildLeaderboardEntry(entries[index], index),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();

    if (!authService.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Leaderboard')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Please login to view the leaderboard'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'By Difficulty'),
            Tab(text: 'Global Rankings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDifficultyLeaderboard(),
          _buildGlobalLeaderboard(),
        ],
      ),
    );
  }
}
