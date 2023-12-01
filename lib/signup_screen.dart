import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _roleController = TextEditingController();
  final _numberController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future signUp() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = <String, dynamic>{
        "first name": _nameController.text.trim(),
        "last name": _lastnameController.text.trim(),
        "number": _numberController.text.trim(),
        "role": _roleController.text.trim(),
      };

      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user?.uid)
          .set(user);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Registered Successfully"),
        backgroundColor: Colors.green, // Customize the color
      ));

      Navigator.of(context).pushReplacementNamed("ListUsers");
    } on FirebaseAuthException catch (e) {
      print(
          "Error creating user: ${e.message}"); // Use ${e.message} to access the error message

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Registration Failed: ${e.message}"),
        backgroundColor: Colors.red, // Customize the color
      ));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastnameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  OutlineInputBorder myBorders() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        color: Colors.blue, // Change the border color
        width: 2,
      ),
    );
  }

  OutlineInputBorder myFocusBorder() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        color: Colors.deepPurple,
        width: 3,
      ),
    );
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromARGB(255, 168, 179, 247),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              const SizedBox(height: 40), // Increased the spacing at the top
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextFormField(
                  controller: _emailController,
                  validator: emailValidator,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email),
                    border: myBorders(),
                    enabledBorder: myBorders(),
                    focusedBorder: myFocusBorder(),
                  ),
                ),
              ),
              // ... rest of the code ...
              Container(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _nameController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    labelText: "Name",
                    enabledBorder: myBorders(),
                    focusedBorder: myFocusBorder(),
                  ),
                ),
              ),
              Container(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _lastnameController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    labelText: "Last Name",
                    enabledBorder: myBorders(),
                    focusedBorder: myFocusBorder(),
                  ),
                ),
              ),
              Container(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextFormField(
                  controller: _passwordController,
                  validator: passwordValidator,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    labelText: "Password",
                    enabledBorder: myBorders(),
                    focusedBorder: myFocusBorder(),
                  ),
                ),
              ),
              Container(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _roleController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    labelText: "Role",
                    enabledBorder: myBorders(),
                    focusedBorder: myFocusBorder(),
                  ),
                ),
              ),
              Container(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextFormField(
                  controller: _numberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone),
                    labelText: "Number",
                    enabledBorder: myBorders(),
                    focusedBorder: myFocusBorder(),
                  ),
                ),
              ),
              Container(height: 20),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GestureDetector(
                  onTap: signUp,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 14, 10, 8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
