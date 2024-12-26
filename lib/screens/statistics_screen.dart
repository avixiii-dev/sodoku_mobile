import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/statistics_service.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Statistics'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Overall'),
              Tab(text: 'Easy'),
              Tab(text: 'Medium'),
              Tab(text: 'Hard'),
              Tab(text: 'Expert'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverallStats(context),
            _buildDifficultyStats(context, 'easy'),
            _buildDifficultyStats(context, 'medium'),
            _buildDifficultyStats(context, 'hard'),
            _buildDifficultyStats(context, 'expert'),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallStats(BuildContext context) {
    final statsService = context.watch<StatisticsService>();
    final stats = statsService.getOverallStats();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatsCard(
              title: 'Overall Progress',
              stats: stats,
              icon: Icons.trending_up,
            ),
            const SizedBox(height: 16),
            _buildStreakCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyStats(BuildContext context, String difficulty) {
    final statsService = context.watch<StatisticsService>();
    final stats = statsService.getDifficultyStats(difficulty);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatsCard(
              title: '${difficulty.toUpperCase()} Statistics',
              stats: stats,
              icon: Icons.bar_chart,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard({
    required String title,
    required Map<String, String> stats,
    required IconData icon,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            ...stats.entries.map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    entry.value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context) {
    final statsService = context.watch<StatisticsService>();
    final stats = statsService.statistics;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.local_fire_department, size: 24),
                SizedBox(width: 8),
                Text(
                  'Streaks',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            _buildStreakIndicator(
              'Current Streak',
              stats.currentStreak,
              Colors.orange,
            ),
            const SizedBox(height: 16),
            _buildStreakIndicator(
              'Best Streak',
              stats.bestStreak,
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakIndicator(String label, int value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$value days',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
