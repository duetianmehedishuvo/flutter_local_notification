import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FlutterLocalNotificationsPlugin fltrNotification;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.local);
    var androidInitialize = const AndroidInitializationSettings('app_icon');
    var iosInitialize = const IOSInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iosInitialize);
    fltrNotification = FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initializationsSettings, onSelectNotification: notificationSelected);
  }

  Future notificationSelected(String? payload) async {
    showDialog(context: context, builder: (context) => AlertDialog(content: Text('Notification : $payload')));
  }

  Future _showOneTimeNotification() async {
    var androidDetails = const AndroidNotificationDetails('channelId', 'Search Islam',
        channelDescription: 'This is My channel', importance: Importance.low, autoCancel: false, colorized: true, ongoing: true);
    var iosDetails = const IOSNotificationDetails();
    var generalNotificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);
    fltrNotification.show(0, 'Task', 'You Create a Task', generalNotificationDetails, payload: 'Task');
  }

  Future _showScheduledTimeNotification() async {
    var androidDetails = const AndroidNotificationDetails('channelId', 'Search Islam',
        channelDescription: 'This is My channel', importance: Importance.low, autoCancel: false, colorized: true, ongoing: true);
    var iosDetails = const IOSNotificationDetails();
    var generalNotificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);
    var scheduledTime = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));

    fltrNotification.zonedSchedule(0, 'this is title', 'this is body', scheduledTime, generalNotificationDetails,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        payload: 'Task');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () {
            _showScheduledTimeNotification();
          },
          color: Colors.red,
          minWidth: double.infinity,
          child: const Text('Notification'),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
