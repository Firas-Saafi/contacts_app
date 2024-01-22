import 'package:flutter/material.dart';  // Importe le package Flutter
import 'package:cloud_firestore/cloud_firestore.dart';  // Importe services Firestore 
import 'package:contacts_app/screens/update_contact_screen.dart';  // Pour accéder à la page update contact contacts
import 'package:contacts_app/services/auth_services.dart';  // Pour les services d'authentification
import 'package:contacts_app/services/firestore_services.dart';  // Pour les services Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Pour utiliser Firebase Authentication
import 'package:url_launcher/url_launcher.dart';  // Pour lancer des URL


class HomeScreen extends StatefulWidget {  // Class Page Home
  const HomeScreen({super.key});   // Constructeur de la classe HomeScreen

  @override 
  State<HomeScreen> createState() => _HomeScreenState();
}

// Classe pour gérer l'état de la page 
class _HomeScreenState extends State<HomeScreen> {
  // Flux de données
  late Stream<QuerySnapshot> _stream;
  // Contrôleur pour le recherche
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchfocusNode = FocusNode();

  @override
    // Méthode appelée lors de la création de l'état de la page
  void initState() {
    // Initialisation du flux avec les contacts depuis Firestore
    _stream = CRUD().getContacts();
    super.initState();
  }

  @override
  // Méthode appelée lors de la suppression de l'état de la page
  void dispose() {
    // Libération des ressources du FocusNode
    _searchfocusNode.dispose();
    super.dispose();
  }

  // Méthode pour appeler le contact en utilisant url_launcher
 call(String phone) async {
  String url = "tel:$phone";  // Création de l'URL 
  // Vérification
  if (await canLaunch(url)) {
     // Lancement de l'URL
    await launch(url);
  } else {
    throw url;  // En cas d'erreur, renvoie un message d'erreur
  }
}

// Méthode pour envoyer un message au contact en utilisant url_launcher
sendMessage(String phone) async {
  String url = "sms:$phone";  // Création de l'URL 
  // Vérification
  if (await canLaunch(url)) {
    // Lancement de l'URL
    await launch(url);
  } else {
    throw url;  // En cas d'erreur, renvoie un message d'erreur
  }
}

 // Méthode pour le recherche
  searchContacts(String search) {
    // Mise à jour du flux avec les contacts filtrés en fonction de la recherche
    _stream = CRUD().getContacts(searchQuery: search);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  //Barre d'application
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Titre de la barre d'application
          Text("Contacts"),
           // Bouton d'ajout de contact
          ElevatedButton(
            onPressed: () {  // Action
              Navigator.pushNamed(context, "/add");   // Navigation vers la page d'ajout de contact
            },
            child: Icon(Icons.person_add),  // Icon du Button
            style: ElevatedButton.styleFrom( // style du Button
              primary: Colors.green,  // Couleur
              elevation: 0, 
            ),
          ),
        ],
      ),
       // Barre de Recherche
      bottom: PreferredSize(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),  // Marge intérieure verticale de 8
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .9,  // Largeur de 90% de la largeur de l'écran
            child: TextFormField(   // widget pour la saisie de texte
              onChanged: (value) {
                // Appel de la méthode de recherche
                searchContacts(value);
                setState(() {});
              },
              focusNode: _searchfocusNode,
              controller: _searchController,   // Contrôleur pour récupérer la valeur saisie
              decoration: InputDecoration(  // Décoration du champ 
                filled: true,
                fillColor: Colors.grey[200],  // Couleur du champ 
                border: OutlineInputBorder(  // Border 
                  borderRadius: BorderRadius.circular(15.0),
                ),
                label: Text("Recherche"),  // Étiquette du champ
                prefixIcon: Icon(Icons.search),  // Icone de recherche
                suffixIcon: _searchController.text.isNotEmpty  // Icône pour effacer la recherche
                ? IconButton(
                  onPressed: () {  // Action
                    _searchController.clear();   // Efface le texte de recherche 
                    _searchfocusNode.unfocus();  // Retire le focus du champ de recherche
                    _stream = CRUD().getContacts();  // Réinitialise le flux pour afficher tous les contacts
                    setState(() {});  // Refresh 
                  },
                  icon: Icon(Icons.close),  // Icone
                )
                : null
              ),
            )
          ),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width * 8, 80)),  // Taille de la barre de recherche
      ),
      
      drawer: Drawer(  // Tiroir latéral  
          child: ListView(
        children: [
          DrawerHeader(  // En-tête
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              CircleAvatar(  // Avatar circulaire
                maxRadius: 40,  // Rayon
                backgroundColor: Colors.blue, // Couleur de Background 
                child: Text(FirebaseAuth.instance.currentUser!.email  // Récupération de l'Email de l'utilisateur actuel
                    .toString()[0]  // Récupération de la première lettre de l'e-mail 
                    .toUpperCase(),  // Mettre en majuscules
                    style: TextStyle(
                    fontSize: 32,   // Taille de police
                    fontWeight: FontWeight.bold, // Poids de police en gras
                   
                  ),
                ),
              ),
              // Espacement vertical
              SizedBox(
                height: 10,  
              ),
              Text(FirebaseAuth.instance.currentUser!.email.toString(),  // Récupération de l'e-mail de l'utilisateur actuel
              style: TextStyle(
                fontSize: 16,  // Taille de police
                fontWeight: FontWeight.bold,  // Poids de police en gras
              ),)
            ],
          )),
          ListTile(
            onTap: () {
              AuthService().logout();  // Appel de la méthode de déconnexion de l'AuthService3
               // Affichage d'un message SnackBar indiquant que l'utilisateur est déconnecté
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Deconnecter")));
              Navigator.pushReplacementNamed(context, "/login");  // Navigation vers l'écran de connexion
            },
            leading: Icon(Icons.logout_outlined),  // Icône de déconnexion
            title: Text("Se Deconnecter"),
          )
        ],
      )),

      // StreamBuilder pour reconstruire l'interface en fonction du flux Firestore
      body: StreamBuilder<QuerySnapshot>(
          stream: _stream,  // Flux de données Firestore
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // En cas d'erreur, affiche un message d'erreur
            if (snapshot.hasError) {
              return Text("Il y a un problème");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(  //centre de l'écran
                child: Text("Chargement..."),  // Affichage d'un indicateur de chargement
              );
            }
            return snapshot.data!.docs.length == 0  
                ? Center(
                    child: Text("Aucun Contact ..."),  // Affiche un message si aucun contact
                  )
                : ListView(
                  children: snapshot.data!.docs
                  .map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                    // Affiche chaque contact sous forme de carte dans une liste
                    return Card(
                      color: Colors.blue[50],  // Couleur de fond de la carte
                      elevation: 3,  // Élévation de la carte
                      margin: EdgeInsets.all(8),  // Marge autour de la carte
                      child: ListTile(
                        onTap: () => Navigator.push(    // Lorsqu'on appuie sur le ListTile, 
                          context,  
                          MaterialPageRoute(
                            builder: (context) => UpdateContact(  // Navigue vers la page de modification 
                              name: data["name"],   // On passe le nom du contact à la page modification 
                              phone: data["phone"], // Le numéro de téléphone
                              email: data["email"], // L'adresse Email  
                              docID: document.id,  // On passe l'ID du document
                            ),
                          ),
                        ),
                        leading: CircleAvatar(   // Avatar circulaire
                          child: Text(data["name"][0].toUpperCase()), // Affichage de la première lettre en majuscules
                          backgroundColor: Colors.blue[400],  // Couleur
                        ),
                        title: Text(
                        data["name"],   // Affichage de Nom
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(data["phone"]),  // Affichage de numéro de téléphone
                      trailing: Row(  // Partie à l'extrême droite du ListTile
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton( 
                            icon: Icon(Icons.message),   // Icône de message
                            color: Colors.blue,  // Couleur de l'icône 
                            onPressed: () {  // Action
                              sendMessage(data["phone"]);  // Appele la Méthode sendMessage
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.call),  // Icône 
                            color: Colors.green,  // Couleur de l'icône 
                            onPressed: () {  // Action
                              call(data["phone"]);   // Appele la Méthode call
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
              )
              .toList()
              .cast(),
          );
        },
      ),
    );
  }
}