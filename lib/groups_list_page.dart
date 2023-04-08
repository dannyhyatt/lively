import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class GroupListPage extends StatefulWidget {
  const GroupListPage({super.key});

  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  List groups = [];

  _GroupListPageState() {
    FirebaseFirestore.instance
        .collection('groups')
        .where('members',
            arrayContains: FirebaseAuth.instance.currentUser!.phoneNumber ?? '')
        .snapshots()
        .listen((snapshot) {
      groups = [];
      snapshot.docs.forEach((element) {
        print(element.data());
        groups.add(element.data());
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('lively'),
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
                              Text(
                                e['name'] ?? 'empty group name',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 28),
                              ),
                              Divider(
                                color: Colors.transparent,
                              ),
                              Text(
                                '${e['members']}'
                                    .substring(1, '${e['members']}'.length - 1),
                                maxLines: 3,
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          Text('O ' + (e['last_live'] ?? ''))
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
