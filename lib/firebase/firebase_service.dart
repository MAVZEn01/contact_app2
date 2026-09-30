import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_app2/feature/data/models/contact_user.dart';

class FirebaseService {
  CollectionReference<ContactUser> collection() {
    return FirebaseFirestore.instance
        .collection("Contact")
        .withConverter<ContactUser>(
          fromFirestore: (snapshot, _) {
            return ContactUser.fromJson({
              ...snapshot.data() ?? <String, dynamic>{},
              "id": snapshot.id,
            });
          },
          toFirestore: (contactUser, _) => contactUser.toJson(),
        );
  }

  Future<void> addUser(ContactUser user) async {
    await collection().add(user);
  }

  Future<void> delete(String id) async {
    await collection().doc(id).delete();
  }

  Future<void> update(ContactUser user) async {
    if (user.id == null) return;
    await collection().doc(user.id).update(user.toJson());
  }

  Future<List<ContactUser>> getAllData() async {
    final snapshot = await collection().get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
