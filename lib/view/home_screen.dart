import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_webspark/helpers.dart';
import 'package:test_webspark/model/response_data.dart';
import 'package:test_webspark/view/process_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isFetching = false;
  late TextEditingController _controller;
  late List calculated;

  @override
  void initState() {
    super.initState();
    calculated = [];
    _controller = TextEditingController(text: '');

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _controller.text = prefs.getString('api_url') ?? '';
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('URL is incorrect'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> startButtonPress(value) async {
    if (isValidUrlWithUrlLauncher(value)) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('api_url', value);

      setState(() {
        isFetching = true;
      });

      ResponseData responseData = await fetchData(value);

      setState(() {
        isFetching = false;
      });

      if (mounted) {
        Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              ProcessScreen(responseData: responseData),
        ));
      }

    } else {
      showSnackBar();
    }
  }

  bool isValidUrlWithUrlLauncher(String url) {
    return url == 'https://flutter.webspark.dev/flutter/api';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Set a valid API base URL in order to continue'),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.sync_alt_outlined),
                  ),
                  onChanged: (value) => setState(() {
                    _controller.text = value;
                  }),
                  onSubmitted: (value) async {
                    startButtonPress(value);
                  },
                ),
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  width: double.maxFinite,
                  height: 50,
                  child: FloatingActionButton(
                      onPressed: isFetching
                          ? () {}
                          : () async {
                              startButtonPress(_controller.text);
                            },
                      child: isFetching
                          ? const CircularProgressIndicator()
                          : const Text('Start counting process')),
                )),
          ],
        ),
      ),
    );
  }
}
