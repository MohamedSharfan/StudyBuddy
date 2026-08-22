class Achievement {
  const Achievement({
    required this.code,
    required this.title,
    required this.description,
    required this.icon,
    required this.unlocked,
  });

  final String code;
  final String title;
  final String description;
  final String icon;
  final bool unlocked;
}
