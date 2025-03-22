/*import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

class PushNotification {
  static final _firebaseMessaging = FirebaseMessaging.instance;

  static Future intt()async{
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,

    );
    final token = await _firebaseMessaging.getToken();
    print('device token: $token');
  }
}


 */

