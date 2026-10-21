import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io' show Platform;

GetStorage box = GetStorage();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.data.isNotEmpty) {
    final data = message.data;
    final String? title = data['title'] ?? '';
    final String? body  = data['body']  ?? '';
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: message.hashCode,
        channelKey: 'default',
        title: title,
        body: body,
        category: NotificationCategory.Reminder,
        notificationLayout: NotificationLayout.Default,
        wakeUpScreen: true,
        payload: {
          'route': data['route'] ?? '',
          'route_id': data['route_id'] ?? '',
          'notifications': data['notifications'] ?? '0',
        },
      ),
    );
  }
}
class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  String? fcm_token;

  Future<void> initNotification() async{
    AwesomeNotifications().initialize('resource://mipmap/ic_launcher', [
        NotificationChannel(
          channelKey: 'default',
          channelName: 'default',
          channelDescription: 'Default Notification',
          defaultColor: Colors.blue,
          importance: NotificationImportance.High,
        )
      ],
    );
    if(await AwesomeNotifications().isNotificationAllowed() == false){AwesomeNotifications().requestPermissionToSendNotifications();}

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data.isNotEmpty) {
        final data = message.data;
        final String? title = data['title'] ?? '';
        final String? body  = data['body']  ?? '';
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: message.hashCode,
            channelKey: 'default',
            title: title,
            body: body,
            category: NotificationCategory.Reminder,
            notificationLayout: NotificationLayout.Default,
            wakeUpScreen: true,
            payload: {
              'route':        data['route'] ?? '',
              'route_id':     data['route_id'] ?? '',
              'notifications': data['notifications'] ?? '0',
            },
          ),
        );
      }
    });

    if (Platform.isIOS) {
      String? apnsToken = await _firebaseMessaging.getAPNSToken();
      if (apnsToken != null) {
        fcm_token = await _firebaseMessaging.getToken();
      } else {
        await Future.delayed(const Duration(seconds: 2));
        apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken != null) {
          fcm_token = await _firebaseMessaging.getToken();
        } else {
          fcm_token = "";
        }
      }
    } else {
      fcm_token = await _firebaseMessaging.getToken();
    }
    box.write('fcm_token', fcm_token);

    AwesomeNotifications().setListeners(onActionReceivedMethod: FirebaseApi.onActionReceivedMethod);
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(ReceivedAction detail) async{
    if(detail.buttonKeyPressed == 'accept'){

    }else if(detail.buttonKeyPressed == 'cancel'){

    }else{
      if (detail.payload != null && detail.payload!['route'] != null && detail.payload!['route_id'] != null) {
        String route = detail.payload!['route']!;
        String route_id = detail.payload!['route_id']!;
        String notifications = detail.payload!['notifications']!;
        box.write('pending_route', route);
        box.write('pending_route_id', route_id);
        if (Get.routing.current != '') {
          if(route != ''){Get.toNamed(route,arguments: {'id':route_id});}
          box.remove('pending_route');
          box.remove('pending_route_id');
        }
      }
    }
  }
}