class Symptom {
  final String id;
  final String name;
  final int weight; // 1: Mild, 3: Moderate, 5: Critical

  // Dibuat tidak final agar state pemilihannya bisa diubah di level UI lokal
  // Namun dalam arsitektur yang lebih ketat, state ini idealnya dipegang oleh Provider.
  bool isSelected;

  Symptom({
    required this.id,
    required this.name,
    required this.weight,
    this.isSelected = false,
  });
}
