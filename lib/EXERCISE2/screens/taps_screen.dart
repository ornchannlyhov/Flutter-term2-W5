import 'package:flutter/material.dart';
import 'package:observer/EXERCISE2/color_counters.dart';
import 'package:provider/provider.dart';

class TapsScreen extends StatelessWidget {
  const TapsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 30),
            textStyle: const TextStyle(fontSize: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            Provider.of<ColorCounters>(context, listen: false).incrementRed();
          },
          child: Consumer<ColorCounters>(
            builder: (context, colorCounters, child) => Text('Taps: ${colorCounters.redCount}'),
          ),
        ),
        const SizedBox(height: 20), // Spacing
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 30),
            textStyle: const TextStyle(fontSize: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            Provider.of<ColorCounters>(context, listen: false).incrementBlue();
          },
          child: Consumer<ColorCounters>(
            builder: (context, colorCounters, child) => Text('Taps: ${colorCounters.blueCount}'),
          ),
        ),
      ],
    );
  }
}