class Conversation {
  final String id;
  final String user1Id;
  final String user2Id;
  final String user1Name;
  final String user2Name;
  final String lastMessage;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.user1Name,
    required this.user2Name,
    required this.lastMessage,
    required this.updatedAt,
  });

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['id'] as String,
      user1Id: map['user1_id'] as String,
      user2Id: map['user2_id'] as String,
      user1Name: map['user1_name'] ?? '',
      user2Name: map['user2_name'] ?? '',
      lastMessage: map['last_message'] ?? '',
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}
