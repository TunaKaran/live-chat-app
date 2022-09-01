import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/firebase_methods.dart/auth_methods.dart';
import 'package:flutter_whatsapp_clone/screens/login.dart';
import 'package:flutter_whatsapp_clone/widgets/user_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Whatsapp Clone'),
          bottom: TabBar(tabs: [
            Tab(
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.camera_alt),
              ),
            ),
            const Tab(
              text: 'Chats',
            ),
            const Tab(
              text: 'Status',
            ),
            const Tab(
              text: 'Calls',
            ),
          ]),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: InkWell(
                      onTap: () async {
                        FirebaseAuthMethods().singOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text('Log Out'),
                    ),
                  ),
                ];
              },
            )
          ],
        ),
        body: TabBarView(
          children: [
            const Center(
              child: Text('Camera'),
            ),
            UserList(uid: _auth.currentUser!.uid),
            const Center(
              child: Text('Status'),
            ),
            const Center(
              child: Text('Calls'),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.message_outlined),
        ),
      ),
    );
  }
}
