class CouturierModel {
  final String firstName;
  final String lastName;
  final String email;
  final String address;
  final String phone;
  final String nationality;
  final String sex;
  final DateTime dateOfBirth;
  final String introduction;
  final String password;  // gardé seulement en mémoire pour Firebase Auth
  final String? imageUrl;
  final String? certificateUrl;
  final bool status;

  CouturierModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address,
    required this.phone,
    required this.nationality,
    required this.sex,
    required this.dateOfBirth,
    required this.introduction,
    required this.password,
    this.imageUrl,
    this.certificateUrl,
    this.status = false,
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
      'introduction': introduction,
      // NE PAS METTRE LE MOT DE PASSE ICI !
      'imageUrl': imageUrl,
      'certificateUrl': certificateUrl,
      'status': status,
    };
  }
}
