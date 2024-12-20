import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_webspark/model/response_data.dart';
import 'package:test_webspark/model/result.dart';
import 'package:test_webspark/path_finder.dart';
import 'package:test_webspark/view/results_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProcessScreen extends StatefulWidget {
  const ProcessScreen({super.key, required this.responseData});

  final ResponseData responseData;

  @override
  State<ProcessScreen> createState() => _ProcessScreenState();
}

class _ProcessScreenState extends State<ProcessScreen> {
  late bool isLoading;
  bool _isSending = false;
  int progress = 0;
  List<List<Point>> shortestPaths = [];
  List<String> shortestPathStrings = [];

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    isLoading = true;

    calculateShortestPath();
  }

  void calculateShortestPath() async {
    for (int i = 0; i < widget.responseData.data.length; i++) {
      final List<List<String>> gridData = (widget.responseData.data[i].field)
          .map((row) =>
              (row).split('').toList())
          .toList();

      final Point start = widget.responseData.data[i].start;
      final Point end = widget.responseData.data[i].end;

      final grid = Grid(gridData);
      final pathFinder = PathFinder(grid);

      await for (var update
          in pathFinder.findShortestPathWithProgress(start, end)) {
        setState(() {
          progress = update['progress'];
        });

        if (update['progress'] == 100) {
          setState(() {
            isLoading = false;
          });

          final path = (update['path'] as List<dynamic>)
              .map((coord) => (coord as List<dynamic>).cast<int>())
              .toList();

          if (path.isNotEmpty) {
            if (shortestPaths.length <= i) {
              shortestPaths.add([]);
            }
            shortestPaths[i] =
                path.map((e) => Point(x: e[0], y: e[1])).toList();

            if (shortestPathStrings.length <= i) {
              shortestPathStrings.add('');
            }

            for (Point p in shortestPaths[i]) {
              shortestPathStrings[i] += p.toString();
              shortestPathStrings[i] += '->';
            }
          } else {
            showSnackBar('Path not found.', isError: false);
          }
        }
      }
    }
  }

  Future<void> sendResults() async {
    setState(() {
      _isSending = true;
      _errorMessage = null;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('api_url') ?? '';

    try {
      final requestBody = jsonEncode([
        {
          "id": widget.responseData.data[0].id,
          "result": {
            "steps": shortestPaths[0].map((e) => e.toJson()).toList(),
            "path": shortestPathStrings[0]
                .substring(0, shortestPathStrings[0].length - 2),
          }
        },
        {
          "id": widget.responseData.data[1].id,
          "result": {
            "steps": shortestPaths[1].map((e) => e.toJson()).toList(),
            "path": shortestPathStrings[1]
                .substring(0, shortestPathStrings[1].length - 2),
          }
        }
      ]);

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "accept": "application/json",
          "Content-Type": "application/json",
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        setState(() {
          _isSending = false;
        });

        List<Result> results = [];
        for (int i = 0; i < widget.responseData.data.length; i++) {
          results.add(Result(
              points: shortestPaths[i],
              field: widget.responseData.data[i].field
                  .map((row) => (row).split('').toList())
                  .toList()));
        }

        if (mounted) {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => ResultsScreen(results)));
        }
      } else {
        setState(() {
          _errorMessage = "Error: ${response.reasonPhrase}";
          _isSending = false;
        });
        if (_errorMessage != null) {
          showSnackBar(_errorMessage!);
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to send results.";
        _isSending = false;
      });
      if (_errorMessage != null) {
        showSnackBar(_errorMessage!);
      }
    }
  }

  void showSnackBar(String error, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: isError ? Colors.red : null,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Process screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (progress == 100)
                    const Text(
                      'All calculations has finished, you can send results to server',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 20),
                  Builder(builder: (context) {
                    return CircularProgressIndicator(
                      backgroundColor: Colors.purple[200],
                      value: progress.toDouble(),
                    );
                  }),
                  const SizedBox(height: 12),
                  Text('$progress %'),
                ],
              ),
            ),
            if (!isLoading)
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    width: double.maxFinite,
                    height: 50,
                    child: FloatingActionButton(
                        foregroundColor: _isSending ? Colors.grey[600] : null,
                        backgroundColor: _isSending ? Colors.grey[300] : null,
                        onPressed: _isSending
                            ? () {}
                            : () async {
                                await sendResults();
                              },
                        child: _isSending
                            ? const CircularProgressIndicator()
                            : const Text('Send results to server')),
                  )),
          ],
        ),
      ),
    );
  }
}
