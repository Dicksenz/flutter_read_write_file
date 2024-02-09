import 'dart:io';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CounterView extends StatefulWidget {
  const CounterView({super.key});

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  int _counter = 0;
  late File _counterFile;

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          return;
        }
      }
    }
  }

  Future<File> _getFile() async {
    // final directory = await getExternalStorageDirectory();
    // final downloadFolder = await getDownloadsDirectory();
    final downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;

    // String? downloadsPath = '${directory?.parent.parent.path}/Download';
    return File('${downloadsDirectory?.path}/dheeraj.txt');
  }

  Future<void> _readFile() async {
    try {
      String contents = await _counterFile.readAsString();
      setState(() {
        _counter = int.parse(contents);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _incrementCounter() async {
    setState(() {
      _counter += 1;
    });
    await _counterFile.writeAsString('$_counter');
  }

  @override
  void initState() {
    _requestPermissions().then((value) {
      _getFile().then((file) {
        _counterFile = file;
        debugPrint(file.toString());
        _readFile();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
      ),
      body: Center(
        child: Text(
          '$_counter',
          style: const TextStyle(
            fontSize: 70,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}
