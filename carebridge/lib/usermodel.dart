class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  final int age;
  final String diagnosis;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.age,
    required this.diagnosis,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'age': age,
      'diagnosis': diagnosis,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      age: map['age'],
      diagnosis: map['diagnosis'],
    );
  }
}
