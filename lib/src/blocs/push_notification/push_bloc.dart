import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

part 'push_event.dart';
part 'push_state.dart';

class PushBloc extends Bloc<PushEvent, PushState> {

  late final FirebaseMessaging _messaging;
  late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late final AndroidNotificationChannel channel;

  PushBloc() : super(PushState(title: '', body: ''));

  @override
  Stream<PushState> mapEventToState(PushEvent event) async* {
    if (event is GetNotifications) {

      channel = AndroidNotificationChannel(
        'channel_app_harxz',
        'Canal para notificacion de registro de usuarios',
        'Canal para notificar registros de usuarios',
        importance: Importance.max,
        playSound: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      _messaging = FirebaseMessaging.instance;

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      final notifications = FirebaseMessaging.onMessage;

      await for (final noti in notifications) {
        flutterLocalNotificationsPlugin.show(
          noti.notification.hashCode,
          noti.notification?.title,
          noti.notification?.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id, channel.name, channel.description,
                priority: Priority.high,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
                showWhen: true),
          ),
        );
        yield PushState(
          title: noti.notification?.title ?? '',
          body: noti.notification?.body ?? '',
        );
      }
    }
  }
}
