class User {
  final int? id;
  final String name;
  final String role;
  final bool isBlocked;

  User({
    this.id,
    required this.name,
    required this.role,
    this.isBlocked = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      name: json['name'] as String,
      role: json['role'] as String,
      isBlocked: json['blocked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'role': role,
      'blocked': isBlocked,
    };
  }
}