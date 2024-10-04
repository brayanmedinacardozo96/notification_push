import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../interface/widget_notification.dart';

class LocalNotification extends IWidgetNotification {
  /*final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();*/

  LocalNotification() {
    AwesomeNotifications().initialize(
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context, parameter) => const Text("");

  @override
  call(parameter) =>
      registerMessage(title: parameter['title'], body: parameter['body']);

  Future<void> registerMessage({
    required String title,
    required String body,
  }) async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: title,
        body: body,
      ),
    );

    /*await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          importance: Importance.max,
          priority: Priority.high,
          ongoing: true,
          styleInformation: BigTextStyleInformation(body),
          icon: 'ic_stat_circle_notifications',
        ),
        iOS: const DarwinNotificationDetails(
          badgeNumber: 1,
        ),
      ),
      payload: title,
    );*/
  }
}
