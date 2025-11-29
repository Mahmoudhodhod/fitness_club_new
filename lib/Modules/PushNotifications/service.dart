import 'dart:developer';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart'
    hide NotificationSettings;
import 'package:authentication/authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../Screens/Chat/chat.dart';
import 'drop_down.dart';
import 'utils.dart';

export 'drop_down.dart';
export 'utils.dart';

class PermissionNotGranted implements Exception {}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final notification = message.data;
  if (notification.isNotEmpty) {
    log('Background message received: ${notification['title'] ?? ''} - ${notification['body'] ?? ''}');
    await showNotification(message, "${message.data}", onMessage: true);
  }
}

Future<void> showNotification(RemoteMessage event, String payload,
    {bool onMessage = false}) async {
  var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
      presentAlert: true, presentBadge: true, presentSound: true);
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'io.fitness.club.urgent', 'iyilikSepti',
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

class PushNotificationService {
  PushNotificationService._();

  static Future<void> requestPermission() async {
    if (Platform.isAndroid) return;
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      throw PermissionNotGranted();
    }
  }

  static Future<String?> getToken() => FirebaseMessaging.instance.getToken();
  static Future<void> initialize([AssetsAudioPlayer? audioPlayer]) async {
    final _audioPlayer = audioPlayer ?? AssetsAudioPlayer();

    if (Platform.isIOS) {
      NotificationSettings settings =
          await FirebaseMessaging.instance.getNotificationSettings();
      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        throw PermissionNotGranted();
      }
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log(message.notification?.title ?? '-');
      _showNotification(_audioPlayer, message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static void registerBackgroundService() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> updateServiceFCM(AuthRepository authRepository) async {
    final token = await FirebaseMessaging.instance.getToken();
    return authRepository.updateFCMToken(fcmToken: token!);
  }

  static void _showNotification(
      AssetsAudioPlayer audioPlayer, RemoteMessage message) {
    try {
      NotificationsUtilities.notificationReceived(audioPlayer);
    } on Exception catch (e) {
      log('Error playing notification sound: $e');
    }

    log('Notification body: ${message.notification?.body}');
    final notification = message.notification;
    if (notification != null) {
      if (Get.context != null) {
        showDropDown(
            title: notification.title ?? '-', body: notification.body ?? '-');
      } else {
        log('Context is null, cannot show dropdown');
      }
    }
  }

  static void _handleNotificationClick(RemoteMessage message) {
    log('Notification clicked with payload: ${message.data}');
    Get.to(
      ChatScreen(),
    );
    // final route = message
    //     .data['route']; // Assuming 'route' key specifies the target route
    // if (route != null) {
    //   Get.toNamed(route,
    //       arguments: message.data); // Navigate with data as arguments
    // } else {
    //   log('No route specified in notification payload.');
    // }
  }
}
