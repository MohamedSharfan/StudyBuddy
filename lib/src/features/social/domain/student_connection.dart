enum ConnectionStatus {
  none,
  pendingOutgoing,
  pendingIncoming,
  connected,
}

class StudentConnection {
  const StudentConnection({
    required this.fromUserId,
    required this.toUserId,
    required this.status,
    required this.createdAt,
  });

  final String fromUserId;
  final String toUserId;
  /// `pending` | `accepted`
  final String status;
  final DateTime createdAt;

  bool involves(String userId) =>
      fromUserId == userId || toUserId == userId;

  Map<String, dynamic> toJson() => {
        'fromUserId': fromUserId,
        'toUserId': toUserId,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
      };

  factory StudentConnection.fromJson(Map<String, dynamic> json) {
    return StudentConnection(
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      status: json['status'] as String,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
