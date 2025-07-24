import 'package:flutter/material.dart';
import 'package:wispurr/utils/constants/colors.dart';

class MessageScreen extends StatefulWidget {
  final String messageID;

  const MessageScreen({
    super.key,
    required this.messageID,
  });

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  notImplementedToast() => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Not Implemented'),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: kBackgroundColor,
        elevation: 1,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Contact Name',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
                Text('Message ID: ${widget.messageID}',
                    style: TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.videocam, color: Colors.white),
              onPressed: () => notImplementedToast()),
          IconButton(
              icon: Icon(Icons.call, color: Colors.white),
              onPressed: () => notImplementedToast()),
          IconButton(
              icon: Icon(Icons.more_vert, color: Colors.white),
              onPressed: () => notImplementedToast()),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final isMe = index % 2 == 0; // Alternates for demo
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isMe ? kSurfaceLevel2 : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      _messages[index],
                      style: TextStyle(
                          fontSize: 16,
                          color: !isMe ? Colors.black : Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
            decoration: BoxDecoration(
              color: kSurfaceLevel2,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon(Icons.emoji_emotions, color: Colors.grey),
                // SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      hintStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none),
                      fillColor: kSurfaceLevel3,
                      filled: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: kAccentPurple,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: () {
                      if (_controller.text.trim().isNotEmpty) {
                        setState(() {
                          _messages.insert(0, _controller.text.trim());
                          _controller.clear();
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: kBackgroundColor,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
