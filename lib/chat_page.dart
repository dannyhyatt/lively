import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChatPage extends StatefulWidget {
  String collectionId, displayName, bio, imageUrl;
  ChatPage(
      {super.key,
      required this.collectionId,
      required this.displayName,
      required this.bio,
      required this.imageUrl});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> chats = [];
  TextEditingController _controller = TextEditingController();

  void initState() {
    super.initState();
    debugPrint(widget.collectionId);
    FirebaseFirestore.instance
        .collection(widget.collectionId)
        .orderBy('sent')
        .snapshots()
        .listen((event) {
      chats = [];
      if (mounted)
        setState(() {
          event.docs.forEach((element) {
            chats.add(element);
          });
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.red,
        ),
        title: Text('check-in with lively'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 120),
        child: ListView.builder(
            itemCount: chats.length,
            itemBuilder: ((context, index) {
              return Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      foregroundImage:
                          NetworkImage(chats[index].data()['imageUrl']),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chats[index].data()['name'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        chats[index].data()['message'],
                        textScaleFactor: 1.2,
                      )
                    ],
                  )
                ],
              );
            })),
      ),
      bottomSheet: Container(
        height: 120,
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection(widget.collectionId)
                              .add({
                            'message': _controller.text,
                            'phoneNumber':
                                FirebaseAuth.instance.currentUser!.phoneNumber,
                            'name': widget.displayName,
                            'bio': widget.bio,
                            'imageUrl': widget.imageUrl,
                            'sent': FieldValue.serverTimestamp()
                          }).then((value) => _controller.text = '');
                        },
                        icon: Icon(Icons.send)),
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
