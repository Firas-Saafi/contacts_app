import 'package:flutter/material.dart';  // Importe le package Flutter
import 'package:contacts_app/services/firestore_services.dart';  // Importe services Firestore 

class AddContact extends StatefulWidget {   // Class Page AddContact
  const AddContact({super.key});   // Constructeur de la classe AddContact

  @override
  State<AddContact> createState() => _AddContactState();
}

// Classe pour gérer l'état de la page 
class _AddContactState extends State<AddContact> {
  // Contrôleurs pour les champs
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();  // Clé globale pour le formulaire
  @override
  Widget build(BuildContext context) {
     // Structure de la page
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter Contact")),   // Titre de la barre d'application
      // Corps de la page
      body: SingleChildScrollView(
        child: Form(
          key: formKey,  // Clé globale du formulaire
          child: Center(
            child: Column(
              children: [
                // Espacement vertical
                SizedBox(
                  height: 20,
                ),
                // Image
                Image.asset(  
                  "images/Contacts.png",  // Path de Image 
                  height: 120,  // Hauteur
                  width: 120,   // Largeur
                ),
                // Espacement vertical
                SizedBox(
                  height: 30,
                ) ,     
                SizedBox(
                  width: MediaQuery.of(context).size.width * .9,  // largeur du champ 
                  child: TextFormField(  // widget pour la saisie de texte
                    validator: (value) =>
                    value!.isEmpty ? "Veillez remplir le nom" : null,  // Validation de champ 
                    controller: _nameController,  // Contrôleur pour récupérer la valeur saisie 
                    decoration: InputDecoration(  // Décoration du champ
                      border: OutlineInputBorder(  // Border 
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      label: Text("Nom"),  // Étiquette du champ
                      prefixIcon: Icon(Icons.person),  // Icône du  champ
                    ),
                  )
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .9,
                  child: TextFormField(
                    validator: (value) =>
                    value!.isEmpty ? "Veillez remplir le Numero de Téléphone" : null,
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      label: Text("Téléphone"),
                      prefixIcon: Icon(Icons.phone),
                    ),
                  )
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .9,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      label: Text("Email"),
                      prefixIcon: Icon(Icons.email)
                    ),
                  )
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 65,  // Hauteur du bouton 
                  width: MediaQuery.of(context).size.width * .7,  // Largeur du bouton
                  child: ElevatedButton(  // Utilise un ElevatedButton 
                    onPressed: () {  // Action lorsque en appui sur le bouton 
                      if (formKey.currentState!.validate()) {   // Vérifie la validité du formulaire 
                        // Appel de la méthode pour ajouter le contact
                        CRUD().addNewContacts(_nameController.text,
                          _phoneController.text, _emailController.text);
                          Navigator.pop(context);  // Retour à l'écran précédent après ajout
                      }
                    },
                    child: Text(
                      "Ajouter",  // Texte affiché sur le bouton
                      style: TextStyle(fontSize: 16),  // Style du texte
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
