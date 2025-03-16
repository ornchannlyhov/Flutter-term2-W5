import 'package:flutter/material.dart';
import 'package:observer/EXERCISE2/color_counters.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Consumer<ColorCounters>(
          builder: (context, colorCounters, child) => Text(
            'Red Taps: ${colorCounters.redCount}',
            style: const TextStyle(fontSize: 20),
          ),
        ),
        const SizedBox(height: 10), // Spacing
        Consumer<ColorCounters>(
          builder: (context, colorCounters, child) => Text(
            'Blue Taps: ${colorCounters.blueCount}',
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
