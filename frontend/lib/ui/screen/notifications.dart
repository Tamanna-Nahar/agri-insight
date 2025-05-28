import 'package:flutter/material.dart';

import 'RootPage.dart';

class notification extends StatefulWidget {
  const notification({Key? key}): super(key: key);

  @override
  State<notification> createState() => _notificationState();
}

class _notificationState extends State<notification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.grey[400],
        leading: BackButton(
        onPressed: () => Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) =>   RootPage()),
    ),
        ),
          title: const Text('Notifications'),

        ),

      body: const Center(
        child: Text('notification Page'),
      ),
    );
  }
}
