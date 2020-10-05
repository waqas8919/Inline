import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:inline/Constants/MyConstants.dart';

class ApiHandler {
  static String baseUrl = "https://fcm.googleapis.com/fcm/send";





  sendNotification(String title, String messege, String token) async {
    var body = {
      "to": token,
      "data": {
        "title": title,
        "message": messege,
      },
      "notification": {"title": title, "body": messege}
    };
    var response = await http.post(baseUrl,
        body: jsonEncode(body),
        headers: ({
          'Content-Type': 'application/json',
          'Authorization': MyConstants.serverKey
        }));

    print("reponse" + response.toString());
  }

}
