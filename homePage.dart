import 'package:demoproject/notifications/notification_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  NotificationsServices notificationsServices = NotificationsServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationsServices.initialiseNotifications();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 200,
          ),
          ElevatedButton(onPressed: () {
            notificationsServices.sendNotification('This is a title', 'This is a body');
          }, child: const Text('Push Notification')),
          ElevatedButton(onPressed: () {

          }, child: const Text('Schedule Notification')),
          ElevatedButton(onPressed: () {

          }, child:
          const Text('Cancel/Stop Notification')),
        ],
      ),
    );
  }
}
