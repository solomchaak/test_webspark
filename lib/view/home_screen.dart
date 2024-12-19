import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Set a valid API baase URL in order to continue'),
                TextField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.sync_alt_outlined),
                  ),
                  onSubmitted: (value) {},
                ),
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  width: double.maxFinite,
                  height: 50,
                  // constraints: BoxConstraints(
                  //     maxHeight: 58,
                  //     maxWidth: (MediaQuery.of(context).size.width > 500
                  //         ? MediaQuery.of(context).size.width / 2
                  //         : 500)),
                  child: FloatingActionButton(
                      onPressed: () {},
                      child: const Text('Start counting process')),
                )),
          ],
        ),
      ),
    );
  }
}
