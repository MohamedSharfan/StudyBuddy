/// All nine provinces of Sri Lanka for local rankings.
enum SriLankaProvince {
  western('Western Province', 'Western'),
  central('Central Province', 'Central'),
  southern('Southern Province', 'Southern'),
  northern('Northern Province', 'Northern'),
  eastern('Eastern Province', 'Eastern'),
  northWestern('North Western Province', 'North Western'),
  northCentral('North Central Province', 'North Central'),
  uva('Uva Province', 'Uva'),
  sabaragamuwa('Sabaragamuwa Province', 'Sabaragamuwa');

  const SriLankaProvince(this.label, this.shortLabel);

  final String label;
  final String shortLabel;

  static SriLankaProvince? tryParse(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final key = raw.trim().toLowerCase();
    for (final p in values) {
      if (p.name.toLowerCase() == key ||
          p.label.toLowerCase() == key ||
          p.shortLabel.toLowerCase() == key) {
        return p;
      }
    }
    return null;
  }
}
