import 'package:flutter/material.dart';
import 'package:test_webspark/model/response_data.dart';
import 'package:test_webspark/path_finder.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen(
      {super.key,
      required this.points,
      required this.grid,
      required this.label});

  final List<Point> points;
  final Grid grid;
  final String label;

  final startColor = const Color(0xFF64FFDA);
  final pathColor = const Color(0xFF4CAF50);
  final endColor = const Color(0xFF009688);
  final lockedColor = const Color(0xFF000000);

  Color getCellColor(List<int> p) {
    if (points.first.x == p[0] && points.first.y == p[1]) {
      return startColor;
    }
    if (points.last.x == p[0] && points.last.y == p[1]) {
      return endColor;
    }

    if (points
        .where((element) => element.x == p[0] && element.y == p[1])
        .toList()
        .isNotEmpty) {
      return pathColor;
    }

    List xPositions = getXPositions(grid.grid);
    if (xPositions
        .where((element) => element.x == p[0] && element.y == p[1])
        .toList()
        .isNotEmpty) {
      return lockedColor;
    }

    return Colors.white;
  }

  List<Point> getXPositions(List<List<String>> grid) {
    List<Point> positions = [];

    for (int y = 0; y < grid.length; y++) {
      for (int x = 0; x < grid[y].length; x++) {
        if (grid[y][x] == 'X') {
          positions.add(Point(x: x, y: y));
        }
      }
    }
    
    return positions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Flexible(
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: grid.cols,
                ),
                itemCount: grid.cols * grid.rows,
                itemBuilder: (context, index) {
                  final x = index % grid.rows;
                  final y = index ~/ grid.cols;
              
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: getCellColor([x, y]),
                    ),
                    child: Center(
                      child: Text(
                        '($x, $y)',
                        style:
                            const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
            Flexible(child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(label, textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
