import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChatPage extends StatefulWidget {
  String collectionId;
  ChatPage({super.key, required this.collectionId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('check-in with lively'),
      ),
      body: Center(child: Text('qqq')),
      bottomSheet: Container(
        height: 120,
        color: Colors.red,
        padding: EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                    suffixIcon:
                        IconButton(onPressed: () {}, icon: Icon(Icons.send)),
                    hintText: 'Your message',
                    border: OutlineInputBorder()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
