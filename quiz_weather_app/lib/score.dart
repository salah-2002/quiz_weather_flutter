import 'package:flutter/material.dart';

class ScoreView extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onRestart;

  const ScoreView({
    super.key,
    required this.score,
    required this.total,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    final percent = ((score / total) * 100).toStringAsFixed(0);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, size: 72),
            const SizedBox(height: 16),
            Text('Your Score', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('$score / $total • $percent%'),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onRestart,
              child: const Text('Restart Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
