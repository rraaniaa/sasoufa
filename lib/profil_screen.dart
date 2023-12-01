import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:picket/signup_screen.dart';

import 'CRUD_DATA/list_user.dart';



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 168, 179, 247), //heedhy zeetha
      //appBar: AppBar(
       // title: const Text("Your Profile Page"),
      //),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUp()),
                );
              },
              icon: const Icon(Icons.tag_faces),
              label: const Text(" Signup"),
            ),
            const SizedBox(
                height: 20), // Ajouter un espace de 20 pixels entre les boutons
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListUsers()),
                );
              },
              icon: const Icon(Icons.list),
              label: const Text("List User"),
            ),
          ],
        ),
      ),
    );
  }
}



