import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notification_push/notification/local_notification.dart';

import '../interface/service_notification.dart';
import '../interface/widget_notification.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  //notificationRepository.insert(jsonEncode(message.data));
}

class FirebaseNotification extends IServiceNotification {
  late final FirebaseMessaging _messaging;
  static String? _token;
  late final IWidgetNotification _widgetNotification;
  static FirebaseNotification? _singleton;

  static String get token => _token ?? "";

  FirebaseNotification._() {
    init();
  }

  factory FirebaseNotification.init() {
    _singleton ??= FirebaseNotification._();

    return _singleton!;
  }

  @override
  backgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  @override
  init({String? topic}) async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    if (topic != null) {
      _messaging.subscribeToTopic(topic);
    }
    _widgetNotification = LocalNotification();
    registerNotification();
  }

  @override
  getToken() async {
    await _messaging.getToken().then((value) {
      _token = value.toString();
    });
  }

  void registerNotification() async {
    await getToken();
    backgroundHandler();
    requestPermission();
  }

  @override
  requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //print('User granted permission');

      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        //  notificationRepository.insert(jsonEncode(message.data));
        if (message.notification != null) {
          _widgetNotification.call({
            "title": message.notification?.title,
            "body": message.notification?.body
          });
          /* LocalNotification(receiveLocalNotification).registerMessage(
              body: message.data['body'], title: message.data['title']);*/
        } else {
          _widgetNotification.call({"title": "Notifications", "body": ""});
          /*LocalNotification(receiveLocalNotification).registerMessage(
              body: message.notification!.body.toString(),
              title: message.notification!.title.toString());*/
        }

        // Navigator.of(ctx).pushNamed('/notification');
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        //print('Message clicked!');
        // Navigator.of(ctx).pushNamed('/notification');
        //print("HOLAAAAAA");
      });
    } else {
      //print('User declined or has not accepted permission');
    }

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      //print('User granted provisional permission');
    } else {
      //print('User declined or has not accepted permission');
    }
  }
}
