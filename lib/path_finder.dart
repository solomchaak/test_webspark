import 'dart:async';
import 'dart:collection';

import 'package:test_webspark/model/response_data.dart';

class PathFinder {
  final Grid grid;
  final List<List<int>> directions = [
    [-1, 0], [1, 0],
    [0, -1], [0, 1],
    [-1, -1], [-1, 1],
    [1, -1], [1, 1],
  ];

  PathFinder(this.grid);

  Stream<Map<String, dynamic>> findShortestPathWithProgress(Point start, Point end) async* {
    Queue<Map<String, dynamic>> queue = Queue();
    Set<String> visited = {};

    List<int> startArr = [start.x, start.y];
    List<int> endArr = [end.x, end.y];


    queue.add({'position': startArr, 'path': [startArr]});
    visited.add(startArr.toString());

    int totalSteps = grid.rows * grid.cols;
    int processedSteps = 0;

    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      final position = current['position'] as List<int>;
      final path = current['path'] as List<List<int>>;

      final int currentX = position[0];
      final int currentY = position[1];

      processedSteps++;
      int progress = ((processedSteps / totalSteps) * 100).toInt();
      yield {'progress': progress, 'path': path};

      if (currentX == endArr[0] && currentY == endArr[1]) {
        yield {'progress': 100, 'path': path};
        return;
      }

      for (final direction in directions) {
        int newX = currentX + direction[0];
        int newY = currentY + direction[1];

        while (grid.isPassable(newX, newY)) {
          final newPosition = [newX, newY];
          if (visited.contains(newPosition.toString())) break;

          visited.add(newPosition.toString());
          queue.add({
            'position': newPosition,
            'path': List<List<int>>.from(path)..add(newPosition),
          });

          break;
        }
      }
    }

    yield {'progress': 100, 'path': []};
  }
}

class Grid {
  final List<List<String>> grid;
  final int rows;
  final int cols;

  Grid(this.grid)
      : rows = grid.length,
        cols = grid[0].length;

  bool isWithinBounds(int x, int y) {
    return x >= 0 && x < cols && y >= 0 && y < rows;
  }

  bool isPassable(int x, int y) {
    return isWithinBounds(x, y) && grid[x][y] == '.';
  }
}