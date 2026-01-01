import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("🔔 BACKGROUND MESSAGE: ${message.notification?.title}");
}
