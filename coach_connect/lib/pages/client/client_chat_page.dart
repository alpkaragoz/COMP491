import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/models/chat_message.dart';

class ClientChatPage extends StatefulWidget {
  final String currentUserId;
  final String chatId;

  const ClientChatPage(
      {super.key, required this.currentUserId, required this.chatId});

  @override
  State<ClientChatPage> createState() => _ClientChatPageState();
}

class _ClientChatPageState extends State<ClientChatPage> {
  final TextEditingController _controller = TextEditingController();
  bool isLoading = true;
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      var chatDoc = await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .get();
      if (chatDoc.exists) {
        isActive = chatDoc['isActive'];
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Chat",
            style: TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
          ),
          backgroundColor: const Color.fromARGB(255, 28, 40, 44),
          iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 226, 182, 167),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 40, 44),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 226, 182, 167),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chat",
          style: TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 40, 44),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 226, 182, 167),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 28, 40, 44),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 226, 182, 167),
                    ),
                  );
                }
                var messages = snapshot.data!.docs
                    .map((doc) => ChatMessage.fromFirestore(
                        doc.data() as Map<String, dynamic>, doc.id))
                    .toList();
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Align(
                        alignment: message.senderId == widget.currentUserId
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                            color: message.senderId == widget.currentUserId
                                ? Color.fromARGB(255, 56, 80, 88)
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            message.text,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (isActive)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: "Type a message",
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 226, 182, 167)),
                        fillColor: const Color.fromARGB(255, 56, 80, 88),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: const TextStyle(
                          color: Color.fromARGB(255, 226, 182, 167)),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send,
                        color: Color.fromARGB(255, 226, 182, 167)),
                    onPressed: () => _sendMessage(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .add({
        'senderId': widget.currentUserId,
        'text': _controller.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _controller.clear();
    }
  }
}
