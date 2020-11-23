import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool recording = false;

  requestPermissions() async {
    await PermissionHandler().requestPermissions([
      PermissionGroup.storage,
      PermissionGroup.photos,
      PermissionGroup.microphone,
    ]);
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Screen Recording'),
        ),
        body: Material(
          child: InkWell(
            onTap: () => !recording ? startScreenRecord() : stopScreenRecord(),
            child: Container(
                child: !recording
                    ? Center(
                        child: Text(
                          "Tap anywhere to start recording",
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Screen recording in progress",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            Text(
                              "Tap anywhere to stop",
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                            ),
                          ],
                        ),
                      )),
          ),
          color: !recording ? Colors.blue : Colors.green,
        ),
      ),
    );
  }

  startScreenRecord() async {
    bool start = false;
    await Future.delayed(const Duration(milliseconds: 1000));
    start = await FlutterScreenRecording.startRecordScreen("Title",
        titleNotification: "dsffad", messageNotification: "sdffd");

    if (start) {
      setState(() => recording = !recording);
    }
    print(start);
    return start;
  }

  stopScreenRecord() async {
    String path = await FlutterScreenRecording.stopRecordScreen;
    setState(() {
      recording = !recording;
    });
    print("Opening video");
    print(path);
    OpenFile.open(path);
  }
}
