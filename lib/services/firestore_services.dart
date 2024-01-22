import 'package:cloud_firestore/cloud_firestore.dart';  // Bibliothèque pour interagir avec la base de données Firestore
import 'package:firebase_auth/firebase_auth.dart';   // Bibliothèque pour gérer l'authentification avec Firebase

 
class CRUD {  // Classe pour effectuer des opérations CRUD sur Firestore

  User? user = FirebaseAuth.instance.currentUser;  //Récupération de utilisateur actuel depuis Firebase Auth

// Ajouter de nouveaux contacts à Firestore
  Future addNewContacts(String name, String phone, String email) async {

    // Crée une data map avec les informations du contact
    Map<String, dynamic> data = {"name": name, "email": email, "phone": phone};
    try {
       // Ajoute la data map à la collection "contacts" sous l'utilisateur actuel
      await FirebaseFirestore.instance    // Accède à l'instance principale de Firestore

          .collection("users")            // Accède à la collection "users"
          .doc(user!.uid)                 // Accède au document de l'utilisateur actuel
          .collection("contacts")         // Accède à la sous-collection "contacts"
          .add(data);                     // Ajoute les données à la collection "contacts"

      print("Contact créé"); // Renvoie un message de réussite
    } catch (e) {
      print(e.toString());  // En cas d'erreur, renvoie un message d'erreur
    }
  }

  // Récupère les documents de la collection "contacts" depuis Firestore
  Stream<QuerySnapshot> getContacts({String? searchQuery}) async* {


    var contactsQuery = FirebaseFirestore.instance

        .collection("users")      // Accède à la collection "users"
        .doc(user!.uid)           // Accède au document de l'utilisateur actuel
        .collection("contacts")   // Accède à la sous-collection "contacts"
        .orderBy("name");         // Ordre les documents par le champ "name"

    // filtre de recherche
    if (searchQuery != null && searchQuery.isNotEmpty) {
      String searchEnd = searchQuery + "\uf8ff";
      contactsQuery = contactsQuery.where("name",
          isGreaterThanOrEqualTo: searchQuery, isLessThan: searchEnd);
    }

     // Récupère les snapshots de la requête des contacts
    var contacts = contactsQuery.snapshots();
    yield* contacts;
  }

  // Met à jour un contact existant dans Firestore
  Future updateContact(
      String name, String phone, String email, String docID) async {
        // Crée une data map avec les nouvelles informations du contact
    Map<String, dynamic> data = {"name": name, "email": email, "phone": phone};
    try {
      // Met à jour le document du contact spécifié
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("contacts")
          .doc(docID)  // Accède au document spécifié par son ID
          .update(data);  // Met à jour le document
      print("Contact mis à jour");  // Renvoie un message de réussite
    } catch (e) {
      print(e.toString());  // En cas d'erreur, renvoie un message d'erreur
    }
  }

  // Suppression de contact
  Future deleteContact(String docID) async {
    try {
      // Supprime le document du contact spécifié 
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("contacts")
          .doc(docID)  // Accède au document spécifié par son ID
          .delete();   // Supprime le document
      print("Contact supprimé");  // Renvoie un message de réussite
    } catch (e) {
      print(e.toString());  // En cas d'erreur, renvoie un message d'erreur
    }
  }
}
