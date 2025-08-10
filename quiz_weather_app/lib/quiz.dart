import 'package:flutter/material.dart';
import 'answer.dart';
import 'question.dart';
import 'score.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<Question> _questions;
  int _qIndex = 0;
  int _score = 0;
  bool _answered = false;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _questions = [
      Question(
        text: 'What is the capital of France?',
        options: [
          AnswerOption(label: 'Berlin', score: 0),
          AnswerOption(label: 'Madrid', score: 0),
          AnswerOption(label: 'Paris', score: 1),
          AnswerOption(label: 'Rome', score: 0),
        ],
        correctIndex: 2,
      ),
      Question(
        text: '2 + 2 = ?',
        options: [
          AnswerOption(label: '3', score: 0),
          AnswerOption(label: '4', score: 1),
          AnswerOption(label: '5', score: 0),
          AnswerOption(label: '22', score: 0),
        ],
        correctIndex: 1,
      ),
      Question(
        text: 'Flutter uses which language?',
        options: [
          AnswerOption(label: 'Java', score: 0),
          AnswerOption(label: 'Dart', score: 1),
          AnswerOption(label: 'Kotlin', score: 0),
          AnswerOption(label: 'Swift', score: 0),
        ],
        correctIndex: 1,
      ),
    ];
  }

  void _pick(int i) {
    if (_answered) return;
    setState(() {
      _answered = true;
      _selectedIndex = i;
      _score += _questions[_qIndex].options[i].score;
    });
  }

  void _next() {
    if (_qIndex < _questions.length - 1) {
      setState(() {
        _qIndex++;
        _answered = false;
        _selectedIndex = null;
      });
    } else {
      // Mark as finished by moving index past the last question
      setState(() {
        _qIndex = _questions.length;
      });
    }
  }

  void _restart() {
    setState(() {
      _qIndex = 0;
      _score = 0;
      _answered = false;
      _selectedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final finished = _qIndex >= _questions.length;
    if (finished) {
      return ScoreView(
        score: _score,
        total: _questions.length,
        onRestart: _restart,
      );
    }

    final q = _questions[_qIndex];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top progress + header (fixed)
            LinearProgressIndicator(value: (_qIndex + 1) / _questions.length),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Question ${_qIndex + 1}/${_questions.length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          q.text,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(q.options.length, (i) {
                      final isSelected = _selectedIndex == i;
                      final isCorrect = q.correctIndex == i;
                      final showState = _answered;
                      return Stack(
                        children: [
                          AnswerButton(
                            text: q.options[i].label,
                            onTap: () => _pick(i),
                          ),
                          if (showState && isSelected)
                            const Positioned(
                              right: 16,
                              top: 10,
                              child: Icon(Icons.check_circle_outline),
                            ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Fixed bottom bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Score: $_score'),
                FilledButton(
                  onPressed: _answered ? _next : null,
                  child: Text(_qIndex == _questions.length - 1 ? 'Finish' : 'Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
