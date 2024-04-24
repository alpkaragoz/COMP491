class Request {
  String senderId;
  String receiverId;

  Request(this.senderId, this.receiverId);

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
    };
  }

  static Request fromJson(Map<String, dynamic> json) {
    return Request(
      json['senderId'] as String,
      json['receiverId'] as String,
    );
  }
}
