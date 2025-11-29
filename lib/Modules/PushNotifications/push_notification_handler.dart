import 'dart:async';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:utilities/utilities.dart';

import '../../Screens/screens.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('hereeeeeeeeeeeeee');
  await showNotification(message, "${message.data}", onMessage: true);
}

void requestPermissions() {
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
}

showNotification(RemoteMessage event, String payload,
    {bool onMessage = false}) async {
  log('eventeventevent ${event.toMap()}');
  var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
      presentAlert: true, presentBadge: true, presentSound: true);
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'io.fitness.club.urgent', 'iyilikSepti',
      color: Color.fromARGB(255, 0, 0, 0),
      icon: '@mipmap/ic_launcher',
      importance: Importance.high,
      priority: Priority.high);
  var notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  String title = "${event.data['title'] ?? ''}";
  String body = "${event.data['body'] ?? ''}";

  await flutterLocalNotificationsPlugin.show(
    200,
    title,
    body,
    notificationDetails,
    payload: payload,
  );
}

initLocalNotification(context) async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse? payload) =>
        handleNotificationsTap(
      payload!.payload,
      NavigationService.navigatorKey.currentContext,
      onMessage: true,
    ),
  );
}

Future<void> registerNotification() async {
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  await _messaging.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );
}

handleNotificationsTap(String? payload, context,
    {bool onMessage = false}) async {
  Navigator.of(
    context,
  ).push(
    MaterialPageRoute(
      builder: (_) => ChatScreen(),
    ),
  );
  // NotificationCubit.get(context).addNotification();

  // log('payloadddddddddddddd $payload');

  // if (payload!.isEmpty || payload == '{}') {
  // } else {
  //   List<String> str =
  //       payload.replaceAll("{", "").replaceAll("}", "").split(",");
  //   log('str. $str');
  //   Map<String, dynamic> data = {};
  // }

  // if (itemType == 'order_status_changes') {
  //   if(AppController.instance.getUserType() != 'owner'){
  //     Navigator.p ush(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => OrderDetailsScreen(
  //           orderId: int.parse(itemId),
  //         ),
  //       ),
  //     );
  //   }else{
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => OrderDetailsOwnerScreen(
  //           orderId: int.parse(itemId),
  //         ),
  //       ),
  //     );
  //   }
  //
  // } else {
  //   Navigator.pushNamed(context, notificationRoute);
  // }
}
