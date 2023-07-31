import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<void> sendDataToServer(Map<String, dynamic> requestData) async {
    String apiURL = 'http://10.0.2.2:8000';

    try {
      final response = await http.post(
        Uri.parse(apiURL),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData['message']);
        print(responseData['data']);
      } else {
        print('Request failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
