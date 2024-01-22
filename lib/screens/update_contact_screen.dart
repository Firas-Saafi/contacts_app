import 'package:flutter/material.dart';  // Importe le package Flutter
import 'package:contacts_app/services/firestore_services.dart';  // Importe services Firestore 


class UpdateContact extends StatefulWidget {  // Déclaration du widget

// Constructeur avec les paramètres requis
  const UpdateContact(  
      {super.key,
      required this.docID,
      required this.name,
      required this.phone,
      required this.email});
      
  final String docID, name, phone, email;  // Propriétés nécessaires

  @override
    // Création de l'état associé à ce widget
  State<UpdateContact> createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateContact> {  // Classe pour gérer l'état de la page 
  // Contrôleurs pour les champs
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();  // Clé globale pour le formulaire

  @override
  // Initialisation de l'état du widget
  void initState() {
    // Pré-remplissage des contrôleurs avec les valeurs actuelles du contact
    _emailController.text = widget.email;
    _phoneController.text = widget.phone;
    _nameController.text = widget.name;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mettre à jour le Contact")),  // Titre de la barre d'application
       // Corps de la page
      body: SingleChildScrollView(
        child: Form(
          key: formKey, // Clé globale du formulaire
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
                  width: 120,  // Largeur
                ),
                SizedBox(
                  height: 30,
                ) ,
                SizedBox(
                    width: MediaQuery.of(context).size.width * .9,  // largeur du champ  
                    child: TextFormField(   // widget pour la saisie de texte 
                      validator: (value) =>
                          value!.isEmpty ? "Veuillez saisir le nom" : null,   // Validation de champ  
                      controller: _nameController,  // Contrôleur pour récupérer la valeur saisie  
                      decoration: InputDecoration(   // Décoration du champ
                        
                        border: OutlineInputBorder(  // Border  
                          borderRadius: BorderRadius.circular(15.0),  
                        ),
                        label: Text("Nom"),  // Étiquette du champ 
                        prefixIcon: Icon(Icons.person), // Icône du  champ
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * .9,  // largeur du champ  
                    child: TextFormField(  // widget pour la saisie de texte 
                      validator: (value) =>
                      value!.isEmpty ? "Veillez remplir le Numero de Téléphone" : null,  // Validation de champ  
                      controller: _phoneController,  // Contrôleur pour récupérer la valeur saisie  
                      keyboardType: TextInputType.number,  // Type de clavier pour saisie numérique
                      decoration: InputDecoration(  // Décoration du champ
                        border: OutlineInputBorder(  // Border  
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        label: Text("Téléphone"),  // Étiquette du champ 
                        prefixIcon: Icon(Icons.phone),  // Icône du  champ
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * .9,  // largeur du champ  
                    child: TextFormField(  // widget pour la saisie de texte 
                      controller: _emailController,  // Contrôleur pour récupérer la valeur saisie  
                      decoration: InputDecoration(  // Décoration du champ
                        border: OutlineInputBorder(  // Border  
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        label: Text("Email"),  // Étiquette du champ 
                        prefixIcon: Icon(Icons.email),  // Icône du  champ
                      ),
                    )),
                SizedBox(
                  height: 36,
                ),
                SizedBox(
                  height: 60,  // Hauteur du bouton
                  width: MediaQuery.of(context).size.width * .5,  // Largeur du bouton
                  child: ElevatedButton(   // Utilise un ElevatedButton
                    onPressed: () {
                      // Dialogue de confirmation
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirmation"),  // Titre de Dialogue de confirmation
                            content: Text("Voulez-vous vraiment modifier ce contact?"),  // Message
                            actions: [
                              TextButton(  // Button sous forme de text 
                                onPressed: () {
                                  Navigator.pop(context);   // Retourne à la page précédent
                                },
                                
                                child: Text("Annuler"), // Titre de button
                              ),
                              TextButton(  // Button sous forme de text 
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {    // Vérifie si le formulaire est valide
                                    // Appelle la méthode de mise à jour du contact
                                    CRUD().updateContact(
                                      _nameController.text,  // Nom 
                                      _phoneController.text, // Numéro de téléphone
                                      _emailController.text,  // Email
                                      widget.docID,  // ID du document
                                    );
                                    Navigator.popUntil(context, ModalRoute.withName('/home')); // Retourne à la page Home
                                  }
                                },
                              
                                child: Text(
                                  "valider",  // Titre de button 
                                  style: TextStyle(color: Colors.green),  // // Style de button
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      "Modifier",  // Titre de Button 
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * .5,
                  child: OutlinedButton(
                    onPressed: () {
                      // Dialogue de confirmation
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirmation"),  // Titre de Dialogue de confirmation
                            content: Text("Voulez-vous supprimer ce contact?"),  // Message 
                            actions: [
                              TextButton(  // Button sous forme de text 
                                onPressed: () {
                                  Navigator.pop(context);   // Retourne à la page précédent
                                },
                                child: Text("Annuler"),  
                              ),
                              TextButton(  // Button sous frome de text
                                onPressed: () {
                                  CRUD().deleteContact(widget.docID);  // Appelle la méthode de suppression du contact 
                                  Navigator.pop(context);  // Retourne à la page précédente
                                  Navigator.pop(context);   // Retourne à la page précédente une fois de plus
                                },
                                child: Text(
                                  "Supprimer",  // Titre de Button 
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      "Supprimer",   // Titre de Button 
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
