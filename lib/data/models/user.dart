class User {
  final int id;
  final String name;
  final String email;
  final String? password;
  final String? role;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    this.role
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.tryParse(json['id']?.toString() ?? '') 
          ?? (throw FormatException('Missing or invalid ID for User: ${json['id']}')),
      name: json['name'],
      email: json['email'],
      password: json['password'],
      role: json['role']
    );
  }
}