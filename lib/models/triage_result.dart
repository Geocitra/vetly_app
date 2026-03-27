enum UrgencyCategory {
  mild, // Ringan -> Protokol Rumah
  moderate, // Sedang -> Konsultasi Digital
  urgent, // Mendesak -> Rujukan Klinik
}

class TriageResult {
  final UrgencyCategory category;
  final int totalScore;
  final String actionLabel;

  const TriageResult({
    required this.category,
    required this.totalScore,
    required this.actionLabel,
  });
}
