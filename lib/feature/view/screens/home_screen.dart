import 'package:contact_app2/core/routes/app_rouet.dart';
import 'package:contact_app2/feature/data/models/contact_user.dart';
import 'package:contact_app2/feature/view/screens/new_contact.dart';
import 'package:contact_app2/firebase/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var users = <ContactUser>[];
  final firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    getAllContact();
  }

  Future<void> addContact() async {
    await Navigator.of(context).pushNamed(AppRouet.newContact);
    getAllContact();
  }

  Future<void> editContact(ContactUser user) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => NewContact(contactUser: user)));
    getAllContact();
  }

  Future<void> deleteContact(ContactUser user) async {
    if (user.id == null) return;
    await firebaseService.delete(user.id!);
    getAllContact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Mazen Contacts",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => CardPerson(
          user: users[index],
          onEdit: () => editContact(users[index]),
          onDelete: () => deleteContact(users[index]),
        ),
        itemCount: users.length,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: addContact,
        child: const Text(
          "Add",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> getAllContact() async {
    final supportsFirebase =
        kIsWeb ||
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
    if (!supportsFirebase) return;

    try {
      users = await firebaseService.getAllData();
      if (mounted) setState(() {});
    } catch (_) {
      if (mounted) setState(() => users = []);
    }
  }
}

class CardPerson extends StatelessWidget {
  const CardPerson({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });

  final ContactUser user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: ListTile(
        title: Text(
          user.name ?? "",
          style: const TextStyle(color: Colors.black),
        ),
        onTap: onEdit,
        subtitle: Text(
          user.phone ?? "",
          style: const TextStyle(color: Colors.cyan, fontSize: 14),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit, color: Colors.blue),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
