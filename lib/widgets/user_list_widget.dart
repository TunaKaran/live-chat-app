import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/screens/chat.dart';

class UserList extends StatefulWidget {
  final String uid;
  const UserList({super.key, required this.uid});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('users').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return ListView.builder(
          itemCount: (snapshot.data! as dynamic).docs.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                          uid: (snapshot.data! as dynamic).docs[index]['uid']),
                    ));
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    (snapshot.data! as dynamic).docs[index]['photoUrl'],
                  ),
                ),
                title:
                    Text((snapshot.data! as dynamic).docs[index]['username']),
              ),
            );
          },
        );
      },
    );
  }
}
