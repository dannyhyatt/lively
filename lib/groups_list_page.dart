import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lively/chat_page.dart';
import 'package:lively/livestream_page.dart';
import 'package:lively/model/mux_live_data.dart';
import 'package:share_plus/share_plus.dart';

import 'package:uni_links/uni_links.dart';

class GroupListPage extends StatefulWidget {
  String displayName, bio, imageUrl;
  GroupListPage(
      {super.key,
      required this.displayName,
      required this.bio,
      required this.imageUrl});

  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  List groups = [];

  _GroupListPageState() {
    StreamSubscription _sub = linkStream.listen((String? link) {
      // Parse the link and warn the user, if it is not correct
      debugPrint('received: $link');
      String groupId = link?.split('/').last ?? '';
      FirebaseFirestore.instance.collection('groups').doc(groupId).update({
        'members': FieldValue.arrayUnion(
            [FirebaseAuth.instance.currentUser!.phoneNumber]),
        'memberData': FieldValue.arrayUnion([
          {
            'phoneNumber': FirebaseAuth.instance.currentUser!.phoneNumber,
            'name': widget.displayName,
            'bio': widget.bio,
            'imageUrl': widget.imageUrl,
          }
        ])
      });
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });

    FirebaseFirestore.instance
        .collection('groups')
        .where('members',
            arrayContains: FirebaseAuth.instance.currentUser!.phoneNumber ?? '')
        .snapshots()
        .listen((snapshot) {
      groups = [];
      snapshot.docs.forEach((element) {
        print(element.data());
        groups.add(element);
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('lively'),
        actions: [
          IconButton(
              onPressed: () async {
                // MuxLiveData liveStream = await createLiveStream();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => ChatPage()));
              },
              icon: Icon(Icons.start))
        ],
      ),
      body: ListView(
        children: groups
            .map((e) => Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    e.data()['name'] ?? 'empty group name',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Share.share(
                                            'https://lively-accef.web.app/join/${e.id}');
                                      },
                                      icon: Icon(Icons.ios_share))
                                ],
                              ),
                              Divider(
                                color: Colors.transparent,
                              ),
                              Text(
                                e.data()['memberData'] is List
                                    ? e
                                        .data()['memberData']
                                        .map((e) => e['name'])
                                        .join(', ')
                                    : '${e.data()['members']}'.substring(
                                        1, '${e.data()['members']}'.length - 1),
                                maxLines: 3,
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          Text('O ' + (e.data()['last_live'] ?? ''))
                        ]),
                  ),
                ))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String text = '';
          var members = [FirebaseAuth.instance.currentUser!.phoneNumber ?? ''];
          showModalBottomSheet(
            context: context,
            builder: (ctx) => Column(
              children: [
                Text('Create a new group'),
                TextField(
                  onChanged: (value) => text = value,
                  decoration: InputDecoration(hintText: 'Group name...'),
                  onSubmitted: ((value) {
                    debugPrint(text);
                    FirebaseFirestore.instance
                        .collection('groups')
                        .add(<String, dynamic>{
                      'name': text,
                      'members': members,
                      'memberData': [
                        {
                          'phoneNumber':
                              FirebaseAuth.instance.currentUser!.phoneNumber,
                          'name': widget.displayName,
                          'bio': widget.bio,
                          'imageUrl': widget.imageUrl,
                        }
                      ]
                    });
                    Navigator.of(ctx).pop();
                  }),
                ),
                TextButton(
                    onPressed: () {
                      debugPrint(text);
                      FirebaseFirestore.instance
                          .collection('groups')
                          .add(<String, dynamic>{
                        'name': text,
                        'members': members,
                        'memberData': [
                          {
                            'phoneNumber':
                                FirebaseAuth.instance.currentUser!.phoneNumber,
                            'name': widget.displayName,
                            'bio': widget.bio,
                            'imageUrl': widget.imageUrl,
                          }
                        ]
                      });
                      Navigator.of(context).pop();
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //     content:
                      //         Text('Copied invite link to clipboard')));
                    },
                    child: Text('Submit'))
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
