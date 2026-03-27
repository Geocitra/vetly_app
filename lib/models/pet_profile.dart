class PetProfile {
  final String id;
  final String name;
  final String breed;
  final int ageInMonths;
  final List<String> vaccineStatus;
  final String imageUrl;

  const PetProfile({
    required this.id,
    required this.name,
    required this.breed,
    required this.ageInMonths,
    required this.vaccineStatus,
    required this.imageUrl,
  });
}
