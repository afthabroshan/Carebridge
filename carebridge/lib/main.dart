// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// void main() async {
//   await Hive.initFlutter();
//   Hive.registerAdapter(UserAdapter());
//   await Hive.openBox<User>('users');
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Auth Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: BlocProvider(
//         create: (context) => AuthCubit(),
//         child: const LoginScreen(),
//       ),
//     );
//   }
// }

// @HiveType(typeId: 0)
// class User extends HiveObject {
//   @HiveField(0)
//   String email;

//   @HiveField(1)
//   String password;

//   @HiveField(2)
//   String name;

//   @HiveField(3)
//   int age;

//   @HiveField(4)
//   String diagnosis;

//   User({
//     required this.email,
//     required this.password,
//     required this.name,
//     required this.age,
//     required this.diagnosis,
//   });
// }

// class AuthCubit extends Cubit<User?> {
//   AuthCubit() : super(null);

//   void login(String email, String password) {
//     final box = Hive.box<User>('users');
//     final user = box.values.firstWhere(
//       (user) => user.email == email && user.password == password,
//       orElse: () =>
//           User(email: '', password: '', name: '', age: 0, diagnosis: ''),
//     );
//     if (user.email.isNotEmpty) {
//       emit(user);
//     }
//   }

//   void signUp(User user) {
//     final box = Hive.box<User>('users');
//     box.put(user.email, user);
//     emit(user);
//   }

//   void logout() {
//     emit(null);
//   }
// }

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final emailController = TextEditingController();
//     final passwordController = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(labelText: 'Email'),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: const InputDecoration(labelText: 'Password'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 BlocProvider.of<AuthCubit>(context)
//                     .login(emailController.text, passwordController.text);
//               },
//               child: const Text('Login'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const SignUpScreen()),
//                 );
//               },
//               child: const Text('Sign Up'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SignUpScreen extends StatelessWidget {
//   const SignUpScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final emailController = TextEditingController();
//     final passwordController = TextEditingController();
//     final nameController = TextEditingController();
//     final ageController = TextEditingController();
//     final diagnosisController = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(title: const Text('Sign Up')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//                 controller: nameController,
//                 decoration: const InputDecoration(labelText: 'Name')),
//             TextField(
//                 controller: emailController,
//                 decoration: const InputDecoration(labelText: 'Email')),
//             TextField(
//                 controller: passwordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(labelText: 'Password')),
//             TextField(
//                 controller: ageController,
//                 decoration: const InputDecoration(labelText: 'Age')),
//             TextField(
//                 controller: diagnosisController,
//                 decoration: const InputDecoration(labelText: 'Diagnosis')),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 final user = User(
//                   email: emailController.text,
//                   password: passwordController.text,
//                   name: nameController.text,
//                   age: int.parse(ageController.text),
//                   diagnosis: diagnosisController.text,
//                 );
//                 BlocProvider.of<AuthCubit>(context).signUp(user);
//                 Navigator.pop(context);
//               },
//               child: const Text('Register'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AccountOverview extends StatelessWidget {
//   const AccountOverview({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = context.watch<AuthCubit>().state;

//     return Scaffold(
//       appBar: AppBar(title: const Text('Account Overview')),
//       body: Center(
//         child: user != null
//             ? Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Name: ${user.name}',
//                       style: const TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.bold)),
//                   Text('Email: ${user.email}'),
//                   Text('Age: ${user.age}'),
//                   Text('Diagnosis: ${user.diagnosis}'),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       BlocProvider.of<AuthCubit>(context).logout();
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const LoginScreen()),
//                       );
//                     },
//                     child: const Text('Logout'),
//                   )
//                 ],
//               )
//             : const Text('No user logged in.'),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'signuppage.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:sqflite_common_ffi/sqflite_common_ffi.dart';

void main() {
  // sqfliteFfiInit();
  // databaseFactory = databaseFactoryFfi;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SQLite Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignUpPage(), // Start with Sign Up page
    );
  }
}
