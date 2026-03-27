import 'package:flutter/material.dart';
import '../models/pet_profile.dart';
import '../models/symptom.dart';
import '../models/triage_result.dart';

class TriageProvider extends ChangeNotifier {
  // 1. Mock Data Pasien (Sesuai spesifikasi Rocky)
  final PetProfile currentPet = const PetProfile(
    id: 'p_rocky_001',
    name: 'Rocky',
    breed: 'Golden Retriever',
    ageInMonths: 4,
    vaccineStatus: ['Rabies (3 Hari Lagi)'],
    // Menggunakan path gambar asli yang baru ditambahkan
    imageUrl: 'lib/public/images/golden-retriever.jpg',
  );

  // 2. State Gejala (The Weighting Engine Data)
  final List<Symptom> _allSymptoms = [
    // Critical (Poin 5)
    Symptom(id: 's1', name: 'Kejang', weight: 5),
    Symptom(id: 's2', name: 'Sesak Napas', weight: 5),
    Symptom(id: 's3', name: 'Pendarahan', weight: 5),

    // Moderate (Poin 3)
    Symptom(id: 's4', name: 'Muntah', weight: 3),
    Symptom(id: 's5', name: 'Diare', weight: 3),
    Symptom(id: 's6', name: 'Lemas', weight: 3),

    // Mild (Poin 1)
    Symptom(id: 's7', name: 'Gatal', weight: 1),
    Symptom(id: 's8', name: 'Luka Kecil', weight: 1),
    Symptom(id: 's9', name: 'Nafsu Makan Turun', weight: 1),
    Symptom(id: 's10', name: 'Bau Mulut', weight: 1),
  ];

  List<Symptom> get allSymptoms => _allSymptoms;

  final List<Symptom> _selectedSymptoms = [];
  List<Symptom> get selectedSymptoms => _selectedSymptoms;

  // 3. State Hasil Triage
  TriageResult? _currentResult;
  TriageResult? get currentResult => _currentResult;

  // 4. Logika Interaksi UI (Toggle)
  void toggleSymptom(Symptom symptom) {
    final index = _allSymptoms.indexWhere((s) => s.id == symptom.id);
    if (index != -1) {
      // Ubah status isSelected secara lokal
      _allSymptoms[index].isSelected = !_allSymptoms[index].isSelected;

      if (_allSymptoms[index].isSelected) {
        _selectedSymptoms.add(_allSymptoms[index]);
      } else {
        _selectedSymptoms.removeWhere((s) => s.id == symptom.id);
      }

      // Kalkulasi ulang setiap kali ada perubahan gejala
      _calculateTriage();

      // Beritahu UI untuk re-render
      notifyListeners();
    }
  }

  // 5. Logika Perhitungan Threshold
  void _calculateTriage() {
    if (_selectedSymptoms.isEmpty) {
      _currentResult = null;
      return;
    }

    // Akumulasi total poin menggunakan fold
    int totalScore = _selectedSymptoms.fold(
      0,
      (sum, item) => sum + item.weight,
    );
    UrgencyCategory category;
    String actionLabel;

    if (totalScore >= 6) {
      category = UrgencyCategory.urgent;
      actionLabel = 'Rujukan Klinik Terdekat';
    } else if (totalScore >= 3) {
      category = UrgencyCategory.moderate;
      actionLabel = 'Konsultasi Dokter Digital';
    } else {
      category = UrgencyCategory.mild;
      actionLabel = 'Lihat Protokol Rumah';
    }

    _currentResult = TriageResult(
      category: category,
      totalScore: totalScore,
      actionLabel: actionLabel,
    );
  }

  // 6. Dynamic Message Generator untuk Chat Simulasi
  String generateDoctorOpeningMessage() {
    if (_selectedSymptoms.isEmpty) {
      return 'Halo, saya Dr. Budi Santoso. Ada yang bisa saya bantu untuk ${currentPet.name} hari ini?';
    }

    final symptomNames = _selectedSymptoms.map((s) => s.name).toList();
    String formattedSymptoms;

    // Formatting string agar natural (contoh: "Muntah", "Muntah dan Diare", "Muntah, Diare, dan Lemas")
    if (symptomNames.length == 1) {
      formattedSymptoms = symptomNames.first;
    } else if (symptomNames.length == 2) {
      formattedSymptoms = '${symptomNames[0]} dan ${symptomNames[1]}';
    } else {
      final lastSymptom = symptomNames.removeLast();
      formattedSymptoms = '${symptomNames.join(', ')}, dan $lastSymptom';
    }

    return 'Halo, saya Dr. Budi. Saya lihat ${currentPet.name} sedang mengalami $formattedSymptoms. Mari kita periksa kondisinya bersama-sama, tetap tenang ya.';
  }
}
