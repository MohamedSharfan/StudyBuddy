class StudentProfile {
  const StudentProfile({
    required this.id,
    required this.name,
    required this.level,
    required this.medium,
    required this.coins,
    required this.streakDays,
    required this.rank,
    this.email,
    this.avatarUrl,
    this.username,
    this.province,
    this.bio,
    this.headline,
  });

  final String id;
  final String name;
  final String level;
  final String medium;
  final int coins;
  final int streakDays;
  final String rank;
  final String? email;
  final String? avatarUrl;
  final String? username;
  final String? province;
  final String? bio;
  final String? headline;

  bool get hasUsername =>
      username != null && username!.trim().isNotEmpty;

  StudentProfile copyWith({
    String? id,
    String? name,
    String? level,
    String? medium,
    int? coins,
    int? streakDays,
    String? rank,
    String? email,
    String? avatarUrl,
    String? username,
    String? province,
    String? bio,
    String? headline,
  }) {
    return StudentProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      medium: medium ?? this.medium,
      coins: coins ?? this.coins,
      streakDays: streakDays ?? this.streakDays,
      rank: rank ?? this.rank,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      username: username ?? this.username,
      province: province ?? this.province,
      bio: bio ?? this.bio,
      headline: headline ?? this.headline,
    );
  }
}
