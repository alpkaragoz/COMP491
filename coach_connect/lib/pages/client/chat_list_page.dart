import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'client_chat_page.dart';

class ChatListPage extends StatefulWidget {
  final String currentUserId;

  const ChatListPage({super.key, required this.currentUserId});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeChats();
  }

  Future<void> _initializeChats() async {
    try {
      // Fetch the current coach ID for the user
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentUserId)
          .get();
      var currentCoachId = userDoc['coachId'];

      if (currentCoachId != null && currentCoachId.isNotEmpty) {
        // Check if the chat document exists
        var chatQuery = await FirebaseFirestore.instance
            .collection('chats')
            .where('participantIds', arrayContains: widget.currentUserId)
            .get();

        var chatExists = chatQuery.docs.any(
            (doc) => (doc['participantIds'] as List).contains(currentCoachId));

        if (!chatExists) {
          // Create the chat document if it doesn't exist
          await FirebaseFirestore.instance.collection('chats').add({
            'participantIds': [widget.currentUserId, currentCoachId],
            'isActive': true,
          });
        }
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

  Future<String> _getUsername(String userId) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc['username'];
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Chats"),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participantIds', arrayContains: widget.currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var chatDocs = snapshot.data!.docs;
          if (chatDocs.isEmpty) {
            return const Center(
              child: Text("No Chats Found."),
            );
          }
          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              var chatDoc = chatDocs[index];
              var chatId = chatDoc.id;
              var participants = chatDoc['participantIds'];
              var otherParticipant =
                  participants.firstWhere((id) => id != widget.currentUserId);

              return FutureBuilder<String>(
                future: _getUsername(otherParticipant),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const ListTile(
                      title: Text("Loading..."),
                    );
                  }
                  var username = snapshot.data!;
                  return ListTile(
                    title: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "Chat with ",
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: username,
                            style: const TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                    subtitle: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chats')
                          .doc(chatId)
                          .collection('messages')
                          .orderBy('timestamp', descending: true)
                          .limit(1)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Text("No messages yet");
                        }
                        var lastMessage = snapshot.data!.docs.first;
                        var messageText = lastMessage['text'];
                        return Text(messageText);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClientChatPage(
                            currentUserId: widget.currentUserId,
                            chatId: chatId,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
