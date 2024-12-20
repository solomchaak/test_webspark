import 'package:flutter/material.dart';
import 'package:test_webspark/model/result.dart';
import 'package:test_webspark/path_finder.dart';
import 'package:test_webspark/widget/list_item.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen(this.results, {super.key});

  final List<Result> results;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Result list screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: results.length,
          itemBuilder: (BuildContext context, int index) {
            return  ListItem(points: results[index].points, grid: Grid(results[index].field),);
          },
        ),
      ),
    );
  }
}
