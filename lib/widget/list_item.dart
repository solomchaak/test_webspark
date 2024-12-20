import 'package:flutter/material.dart';
import 'package:test_webspark/model/response_data.dart';
import 'package:test_webspark/path_finder.dart';
import 'package:test_webspark/view/preview_screen.dart';

class ListItem extends StatelessWidget {
  const ListItem({super.key, required this.points, required this.grid});

  final List<Point> points;
  final Grid grid;

  @override
  Widget build(BuildContext context) {
    String label = '';

    for (Point p in points) {
      label += p.toString();
      label += '->';
    }

    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) => PreviewScreen(points: points, grid: grid, label: label.substring(0, label.length - 2)),
      )),
      child: Container(
        color: Colors.purple[200],
        margin: const EdgeInsets.symmetric(vertical: 3.0),
        padding: const EdgeInsets.all(7.0),
        child: Center(child: Text(label.substring(0, label.length - 2))),
      ),
    );
  }
}
