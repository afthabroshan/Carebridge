// class User {
//   final int? id;
//   final String name;
//   final String email;
//   final String password;
//   final int age;
//   final String diagnosis;
//   int score = 0; // Add this field

//   User({
//     this.id,
//     required this.name,
//     required this.email,
//     required this.password,
//     required this.age,
//     required this.diagnosis,
//     required this.score,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//       'password': password,
//       'age': age,
//       'diagnosis': diagnosis,
//     };
//   }

//   factory User.fromMap(Map<String, dynamic> map) {
//     return User(
//       id: map['id'],
//       name: map['name'],
//       email: map['email'],
//       password: map['password'],
//       age: map['age'],
//       diagnosis: map['diagnosis'],
//       score: map['score'] ?? 0,
//     );
//   }
// }

class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  final int age;
  final String diagnosis;
  int speechTherapyScore;
  int emotionTherapyScore;
  int shapeMatchingScore;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.age,
    required this.diagnosis,
    this.speechTherapyScore = 0,
    this.emotionTherapyScore = 0,
    this.shapeMatchingScore = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'age': age,
      'diagnosis': diagnosis,
      'speechTherapyScore': speechTherapyScore,
      'emotionTherapyScore': emotionTherapyScore,
      'shapeMatchingScore': shapeMatchingScore,
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
      speechTherapyScore: map['speechTherapyScore'] ?? 0,
      emotionTherapyScore: map['emotionTherapyScore'] ?? 0,
      shapeMatchingScore: map['shapeMatchingScore'] ?? 0,
    );
  }
}
