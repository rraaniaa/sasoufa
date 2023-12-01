import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListUsers extends StatefulWidget {
  const ListUsers({Key? key}) : super(key: key);


  @override
  _ListUsersState createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection("users");

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  // Fonction pour mettre à jour un utilisateur
  Future<void> _update(DocumentSnapshot? documentSnapshot) async {
    if (documentSnapshot != null) {
      _firstnameController.text = documentSnapshot["first name"];
      _lastnameController.text = documentSnapshot["last name"];
      _numberController.text = documentSnapshot["number"].toString();
    }

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _firstnameController,
                decoration: const InputDecoration(labelText: "First Name"),
              ),
              TextField(
                controller: _lastnameController,
                decoration: const InputDecoration(
                  labelText: "Last Name",
                ),
              ),
              TextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: _numberController,
                decoration: const InputDecoration(
                  labelText: "Number",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: const Text("Update"),
                onPressed: () async {
                  // Vous pouvez ajouter ici la logique de mise à jour des données
                  String newFirstName = _firstnameController.text;
                  String newLastName = _lastnameController.text;
                  int newNumber = int.tryParse(_numberController.text) ?? 0;

                  if (newNumber != null) {
                    await _users.doc(documentSnapshot?.id).update({
                      "first name": newFirstName,
                      "last name": newLastName,
                      "number": newNumber,
                    });
                  }

                  // Fermez le bottom sheet après la mise à jour
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _create() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _firstnameController,
                decoration: const InputDecoration(labelText: "First Name"),
              ),
              TextField(
                controller: _lastnameController,
                decoration: const InputDecoration(
                  labelText: "Last Name",
                ),
              ),
              TextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: _numberController,
                decoration: const InputDecoration(
                  labelText: "Number",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: const Text("Create"),
                onPressed: () async {
                  // Récupérez les valeurs des champs
                  String newFirstName = _firstnameController.text;
                  String newLastName = _lastnameController.text;
                  int newNumber = int.tryParse(_numberController.text) ?? 0;

                  // Vérifiez si les valeurs ne sont pas nulles (facultatif)
                  if (newFirstName.isNotEmpty && newLastName.isNotEmpty) {
                    // Ajoutez l'utilisateur à la base de données
                    await _users.add({
                      "first name": newFirstName,
                      "last name": newLastName,
                      "number": newNumber,
                    });

                     // Réinitialisez les contrôleurs des champs du formulaire
                  _firstnameController.clear();
                  _lastnameController.clear();
                  _numberController.clear();
                  }

                  // Fermez le bottom sheet après la création
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(DocumentSnapshot documentSnapshot) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm deletion"),
          content: Text("Are you sure you want to delete this user?"),
          actions: <Widget>[
            TextButton(
              child: Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Confirmer"),
              onPressed: () async {
                await _delete(documentSnapshot);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _delete(DocumentSnapshot documentSnapshot) async {
    await _users.doc(documentSnapshot.id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color.fromARGB(255, 168, 179, 247),
      body: StreamBuilder(
        stream: _users.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!streamSnapshot.hasData) {
            return Center(
              child: Text('No data available.'),
            );
          }

          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(documentSnapshot['first name']),
                  subtitle: Text(documentSnapshot['last name'].toString()),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _update(documentSnapshot),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _confirmDelete(
                              documentSnapshot), // Utilisez _confirmDelete
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
