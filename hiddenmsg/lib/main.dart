import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? whatsappFolderUri;
  List<String> seenFiles = [];

  @override
  void initState() {
    super.initState();
    initNotifications();
    loadLastUri();
  }

  Future<void> initNotifications() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );
    await notificationsPlugin.initialize(initSettings);
  }

  Future<void> loadLastUri() async {
    final prefs = await SharedPreferences.getInstance();
    whatsappFolderUri = prefs.getString('whatsappUri');
    if (whatsappFolderUri != null) {
      startMonitoring();
    }
  }

  Future<void> pickFolder() async {
    final uri = await StorageAccessFramework.openDocumentTree();
    if (uri != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('whatsappUri', uri);
      whatsappFolderUri = uri;
      startMonitoring();
    }
  }

  void startMonitoring() {
    Timer.periodic(Duration(seconds: 5), (_) async {
      if (whatsappFolderUri == null) return;
      final files = await StorageAccessFramework.listFiles(whatsappFolderUri!);
      for (final file in files) {
        if (file.endsWith('.jpg') || file.endsWith('.png')) {
          if (!seenFiles.contains(file)) {
            seenFiles.add(file);
            showNotification();
          }
        }
      }
    });
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'hidden_msg_channel',
          'Stego Notifier',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails notifDetails = NotificationDetails(
      android: androidDetails,
    );

    await notificationsPlugin.show(
      0,
      'I am here',
      'A new image was downloaded!',
      notifDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HiddenMsg',
      home: Scaffold(
        appBar: AppBar(title: Text("HiddenMsg")),
        body: Center(
          child: ElevatedButton(
            onPressed: pickFolder,
            child: Text("Grant WhatsApp Image Access"),
          ),
        ),
      ),
    );
  }
}
