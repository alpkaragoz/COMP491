import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'coach_chat_page.dart';

class CoachChatListPage extends StatefulWidget {
  final String coachId;

  const CoachChatListPage({super.key, required this.coachId});

  @override
  State<CoachChatListPage> createState() => _CoachChatListPageState();
}

class _CoachChatListPageState extends State<CoachChatListPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeChats();
  }

  Future<void> _initializeChats() async {
    try {
      // Fetch all client IDs associated with this coach
      var clientsQuery = await FirebaseFirestore.instance.collection('users')
          .where('coachId', isEqualTo: widget.coachId)
          .get();

      var clientIds = clientsQuery.docs.map((doc) => doc.id).toList();

      // Check and create chat documents if they don't exist
      for (var clientId in clientIds) {
        var chatQuery = await FirebaseFirestore.instance.collection('chats')
            .where('participantIds', arrayContains: widget.coachId)
            .get();

        var chatExists = chatQuery.docs.any((doc) => (doc['participantIds'] as List).contains(clientId));

        if (!chatExists) {
          // Create the chat document if it doesn't exist
          await FirebaseFirestore.instance.collection('chats').add({
            'participantIds': [widget.coachId, clientId],
            'isActive': true,
          });
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error initializing chats: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> _getUsername(String userId) async {
    var userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
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
            .where('participantIds', arrayContains: widget.coachId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var chatDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              var chatDoc = chatDocs[index];
              var chatId = chatDoc.id;
              var participants = chatDoc['participantIds'];
              var otherParticipant = participants.firstWhere((id) => id != widget.coachId);

              return FutureBuilder<String>(
                future: _getUsername(otherParticipant),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const ListTile(
                      title: Text("No Chats Found."),
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
                          builder: (context) => CoachChatPage(
                            coachId: widget.coachId,
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
