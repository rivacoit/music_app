import 'package:flutter/material.dart';
import 'api_helper.dart';

class ServerCommunicationPage extends StatefulWidget {
  const ServerCommunicationPage({super.key});

  @override
  State<ServerCommunicationPage> createState() =>
      _ServerCommunicationPageState();
}

class _ServerCommunicationPageState extends State<ServerCommunicationPage> {
  void _sendDataToServer() {
    Map<String, dynamic> requestData = {
      'key1': 'value1',
      'key2': 'value2',
    };
    ApiService.sendDataToServer(requestData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _sendDataToServer();
          },
          child: Text('Send Data to Server'),
        ),
      ),
    );
  }
}
