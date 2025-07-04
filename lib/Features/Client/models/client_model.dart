class ClientModel {
  final String firstName;
  final String lastName;
  final String email;
  final String address;
  final String phone;
  final String nationality;
  final String sex;
  final DateTime dateOfBirth;
  final String imageUrl;
  final bool status; // Champ caché (true par défaut)

  ClientModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address,
    required this.phone,
    required this.nationality,
    required this.sex,
    required this.dateOfBirth,
    required this.imageUrl,
    this.status = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'address': address,
      'phone': phone,
      'nationality': nationality,
      'sex': sex,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'imageUrl': imageUrl,
      'status': status,
    };
  }
}
