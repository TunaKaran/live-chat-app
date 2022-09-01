import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/firebase_methods.dart/firestore_methods.dart';

class ChatScreen extends StatefulWidget {
  final String uid;
  const ChatScreen({super.key, required this.uid});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var userData = {};
  bool isLoading = false;
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(userData['photoUrl']),
                  ),
                  Text(userData['username']),
                ],
              ),
              actions: [
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.video_call)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
                PopupMenuButton(
                  itemBuilder: (context) {
                    return [];
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('chats')
                        .doc('${_auth.currentUser!.uid}-${widget.uid}')
                        .collection('messages')
                        .orderBy('time')
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      return ListView.builder(
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              (snapshot.data! as dynamic).docs[index]
                                          ['senderId'] ==
                                      _auth.currentUser!.uid
                                  ? Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        constraints:
                                            const BoxConstraints(maxWidth: 250),
                                        margin: const EdgeInsets.all(8),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.teal.shade100,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          (snapshot.data! as dynamic)
                                              .docs[index]['text'],
                                        ),
                                      ),
                                    )
                                  : Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Container(
                                        constraints:
                                            const BoxConstraints(maxWidth: 250),
                                        margin: const EdgeInsets.all(8),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                            topRight: Radius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          (snapshot.data! as dynamic)
                                              .docs[index]['text'],
                                        ),
                                      ),
                                    )
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _controller,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0))),
                              hintText: 'Type a message'),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            FirestoreMethods().sendMessage(
                                text: _controller.text,
                                reciverId: widget.uid,
                                senderId: _auth.currentUser!.uid,
                                time: DateTime.now());
                            setState(() {
                              _controller.clear();
                            });
                          },
                          icon: const Icon(Icons.send))
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
