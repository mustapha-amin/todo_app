import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future shownotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    return _notifications.show(
      id, 
      title, 
      body, 
      await _notificationDetails(), 
      payload: payload,
    );
  }
}
