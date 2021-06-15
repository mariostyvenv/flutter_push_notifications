import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harxz/src/blocs/push_notification/push_bloc.dart';
import 'package:harxz/src/pages/login/login_page.dart';

Future<void> _sendNotificationBackground(
  RemoteMessage message,
) async {
  print(message.notification?.title);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_sendNotificationBackground);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => PushBloc(),
        ),
      ],
      child: Harxz(),
    ),
  );
}

class Harxz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Harxz',
      home: LoginPage(),
    );
  }
}
