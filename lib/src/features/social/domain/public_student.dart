import 'sri_lanka_province.dart';

/// Public student card — searchable, rankable, shareable.
class PublicStudent {
  const PublicStudent({
    required this.id,
    required this.username,
    required this.displayName,
    required this.province,
    required this.level,
    required this.medium,
    required this.coins,
    required this.rank,
    required this.streakDays,
    required this.badgeCodes,
    this.bio = '',
    this.headline = '',
    this.avatarUrl,
    this.email,
    this.isLocalUser = false,
  });

  final String id;
  final String username;
  final String displayName;
  final SriLankaProvince province;
  final String level;
  final String medium;
  final int coins;
  final String rank;
  final int streakDays;
  final List<String> badgeCodes;
  final String bio;
  final String headline;
  final String? avatarUrl;
  final String? email;
  final bool isLocalUser;

  String get profilePath => '/u/$username';
  String get shareUrl => 'https://studybuddy.lk/u/$username';

  PublicStudent copyWith({
    String? id,
    String? username,
    String? displayName,
    SriLankaProvince? province,
    String? level,
    String? medium,
    int? coins,
    String? rank,
    int? streakDays,
    List<String>? badgeCodes,
    String? bio,
    String? headline,
    String? avatarUrl,
    String? email,
    bool? isLocalUser,
  }) {
    return PublicStudent(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      province: province ?? this.province,
      level: level ?? this.level,
      medium: medium ?? this.medium,
      coins: coins ?? this.coins,
      rank: rank ?? this.rank,
      streakDays: streakDays ?? this.streakDays,
      badgeCodes: badgeCodes ?? this.badgeCodes,
      bio: bio ?? this.bio,
      headline: headline ?? this.headline,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      email: email ?? this.email,
      isLocalUser: isLocalUser ?? this.isLocalUser,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'displayName': displayName,
        'province': province.name,
        'level': level,
        'medium': medium,
        'coins': coins,
        'rank': rank,
        'streakDays': streakDays,
        'badgeCodes': badgeCodes,
        'bio': bio,
        'headline': headline,
        'avatarUrl': avatarUrl,
        'email': email,
        'isLocalUser': isLocalUser,
      };

  factory PublicStudent.fromJson(Map<String, dynamic> json) {
    return PublicStudent(
      id: json['id'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      province: SriLankaProvince.tryParse(json['province'] as String?) ??
          SriLankaProvince.western,
      level: json['level'] as String? ?? 'O/L',
      medium: json['medium'] as String? ?? 'Tamil',
      coins: json['coins'] as int? ?? 0,
      rank: json['rank'] as String? ?? 'Bronze',
      streakDays: json['streakDays'] as int? ?? 0,
      badgeCodes: (json['badgeCodes'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      bio: json['bio'] as String? ?? '',
      headline: json['headline'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      email: json['email'] as String?,
      isLocalUser: json['isLocalUser'] as bool? ?? false,
    );
  }
}
