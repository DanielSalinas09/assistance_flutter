class UserModel {
  final String id;
  final String name;
  final String surnames;
  final int dni;
  final int phone;
  final String academic_program;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.surnames,
    required this.dni,
    required this.phone,
    required this.academic_program,
    required this.email,
  });

  factory UserModel.fromJsonMap(Map<String, dynamic> json) {
    return UserModel(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        surnames: json['surnames'] ?? '',
        dni: json['dni'] ?? '',
        phone: json['phone'] ?? '',
        academic_program: json['academic_program'] ?? '',
        email: json['email'] ?? '');
  }
}
