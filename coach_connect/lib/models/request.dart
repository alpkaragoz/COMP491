class Request {
  String id;
  String senderId;
  String receiverId;
  String senderUsername;
  String receierUsername;

  // Constructor now includes an ID
  Request(this.id, this.senderId, this.receiverId, this.senderUsername, this.receierUsername);

  // Convert Request object to map, including the id
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderUsername': senderUsername,
      'receiverUsername': receierUsername,
    };
  }

  // Factory method to create a Request from JSON map and include the document ID
  static Request fromJson(Map<String, dynamic> json, String documentId) {
    return Request(
      documentId,
      json['senderId'] as String,
      json['receiverId'] as String,
      json['senderUsername'] as String,
      json['receiverUsername'] as String,
    );
  }
}
