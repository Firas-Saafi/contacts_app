import 'package:flutter/material.dart';                     // Importe le package Flutter
import 'package:contacts_app/services/auth_services.dart';  // Importe le service d'authentification
import 'package:google_fonts/google_fonts.dart';            // Importe les polices Google Fonts



class LoginScreen extends StatefulWidget {    // Class Page de connexion
  const LoginScreen({super.key}); // Constructeur de la classe LoginScreen

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>(); // Clé globale pour le formulaire
   // Contrôleurs pour les champs
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;   // Variable pour gérer la visibilité du mot de passe
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(  // Contenu principal de notre page 
        child: Form(
          key: formKey, // Clé globale du formulaire
          child: Column(children: [
             
            SizedBox(
              height: 120,  // Espacement vertical
            ),  
            Image.asset(     // Image du logo  
              "images/Contacts.png",
                height: 120,       
                width: 120,
            ),
            SizedBox(
              height: 20,
            ),
            Text(     // Texte 
              "Se Connecter",
              style:
                  GoogleFonts.sora(fontSize: 32, fontWeight: FontWeight.w700),  // Le style de Text
            ),
            
            SizedBox(
              height: 20,  // Espacement vertical
            ),
            SizedBox(    
                width: MediaQuery.of(context).size.width * .9,  // largeur du champ 
                child: TextFormField(  // widget pour la saisie de texte
                  validator: (value) =>
                      value!.isEmpty ? "L'e-mail ne peut pas être vide." : null,  // Validation de champ
                  controller: _emailController,   // Contrôleur pour récupérer la valeur saisie
                  decoration: InputDecoration(   // Décoration du champ
                    border: OutlineInputBorder(    // Border 
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    filled: true,  // Remplissage du champ 
                    fillColor: Colors.grey[200], // Couleur du champ
                    label: Text("Email"),        // Étiquette du champ
                    prefixIcon: Icon(Icons.email),   // Icône du  champ
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextFormField(
              validator: (value) =>
                  value!.length < 8 ? "Le mot de passe doit au moins 8 caractères." : null,  // Validation de champ
              controller: _passwordController,  // Contrôleur pour récupérer la valeur saisie
              obscureText: !_isPasswordVisible,  // Le champ de saisie du mot de passe est masqué
              decoration: InputDecoration(
                
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                filled: true,
                fillColor: Colors.grey[200], // Couleur du champ
                labelText: "Mot de passe",  // Étiquette du champ
                prefixIcon: Icon(Icons.lock), // Icône du  champ
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,  // Couleur de l'icône
                  ),
                  onPressed: () {  // Action lorsque l'utilisateur appuie sur l'icône
                    setState(() {
                      // Inverse la visibilité du mot de passe
                      _isPasswordVisible = !_isPasswordVisible;  
                    });
                  },
                ),
              ),
            ),
          ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
                height: 60,  // Hauteur du bouton
                width: MediaQuery.of(context).size.width * .7,     // Largeur du bouton
                child: ElevatedButton(  // Utilise un ElevatedButton 
                    onPressed: () {     // Action lorsque en appui sur le bouton
                      if (formKey.currentState!.validate()) {    // Vérifie la validité du formulaire
                        AuthService()   // Appelle la méthode de connexion de AuthService
                            .loginWithEmail(
                                _emailController.text, _passwordController.text)
                            .then((value) {

                          // Renvoie un message de réussite et navigue vers Home
                          if (value == "Connexion réussie.") { 
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Connexion réussie")));
                            Navigator.pushReplacementNamed(context, "/home");
                          } else {
                            // En cas d'erreur, renvoie un message d'erreur
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                value,
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.green.shade400,
                            ));
                          }
                        });
                      }
                    },
                    // Texte sur le bouton
                    child: Text(
                      "Connexion",
                      style: TextStyle(fontSize: 16),
                      
                    ))),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width * .7,
              child: OutlinedButton(
                  onPressed: () {
                    AuthService().continueWithGoogle().then((value) { // Appelle la méthode de connexion avec google de AuthService
                    // Renvoie un message de réussite et navigue vers Home
                      if (value == "Connexion réussie avec Google") {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Connexion réussie avec Google")));
                        Navigator.pushReplacementNamed(context, "/home");
                      } else {
                         // En cas d'erreur, renvoie un message d'erreur
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            value,
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.green.shade400,
                        ));
                      }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image Google
                      Image.asset(
                        "images/google.png",
                        height: 30,
                        width: 30,
                      ),
                      // Espacement horizontal entre l'image et le texte
                      SizedBox(
                        width: 10,
                      ),
                       // Texte sur le bouton
                      Text(
                        "Continuer avec Google",
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            // Ligne contient texte et un bouton
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Vous n'avez pas de compte ?"),

                 // Bouton pour naviguer vers la page d'inscription
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: Text("S'inscrire"))
              ],
            )
          ]),
        ),
      ),
    );
  }
}
