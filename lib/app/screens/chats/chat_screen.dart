import 'package:flutter/material.dart';
import 'package:wispurr/app/widgets/chat_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0d0d0d),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/brand.png', height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Icon(Icons.search, color: Colors.black),
                      ),
                      GestureDetector(
                        child: Image.asset(
                          'assets/icons/more.png',
                          height: 35,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
                child: ListView.builder(
              itemBuilder: (ctx, idx) => chatWidget(
                title: "User1",
                message: "Hello",
              ),
              itemCount: 10,
            ))
          ],
        ),
      ),
    );
  }
}
