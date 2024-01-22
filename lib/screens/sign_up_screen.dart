import 'package:flutter/material.dart';  // Importe le package Flutter
import 'package:contacts_app/services/auth_services.dart';  // Importe le service d'authentification
import 'package:google_fonts/google_fonts.dart';  // Importe les polices Google Fonts

class SignUpScreen extends StatefulWidget {  // Class Page d'inscription
  const SignUpScreen({super.key});  // Constructeur de la classe SignUpScreen

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>(); // Clé globale pour le formulaire
  // Contrôleurs pour les champs
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  // Variables pour gérer la visibilité du mot de passe
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // SingleChildScrollView pour permettre le défilement de la vue
        child: Form(
          // Form pour gérer les champs de saisie et la validation du formulaire
          key: formKey, // Clé globale du formulaire
          child: Column(children: [
            SizedBox(
              height: 120, // Espacement vertical
            ),
            // Image du logo
            Image.asset(
              "images/Contacts.png", // Path de l'image
              height: 120,
              width: 120,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "S'inscrire",
              style:
                  GoogleFonts.sora(fontSize: 32, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
                width:
                    MediaQuery.of(context).size.width * .9, // largeur du champ
                child: TextFormField(
                  // widget pour la saisie de texte
                  validator: (value) => value!.isEmpty
                      ? "L'e-mail ne peut pas être vide."
                      : null, // Validation de champ
                  controller:
                      _emailController, // Contrôleur pour récupérer la valeur saisie de email
                  decoration: InputDecoration(
                    // Décoration du champ
                    border: OutlineInputBorder(
                      // Border
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    filled: true, // Remplissage du champ
                    fillColor: Colors.grey[200], // Couleur du champ
                    label: Text("Email"), // Étiquette du champ
                    prefixIcon: Icon(Icons.email), // Icône du champ
                  ),
                )),
            // Espacement vertical
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextFormField(
                validator: (value) => value!.length < 8
                    ? "Le mot de passe doit comporter au moins 8 caractères."
                    : null, // Validation de champ
                controller:
                    _passwordController, // Contrôleur pour récupérer la valeur saisie de mot de passe
                obscureText:
                    !_isPasswordVisible, // Le champ de saisie du mot de passe est masqué
                decoration: InputDecoration(
                  labelText: "Mot de passe",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      // Action lorsque l'utilisateur appuie sur l'icône
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
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextFormField(
                validator: (value) {
                  if (value != _passwordController.text) {
                    return "Les mots de passe ne correspondent pas.";
                  }
                  return null;
                },
                controller: _confirmPasswordController,
                obscureText:
                    !_isConfirmPasswordVisible, // Le champ de saisie du mot de passe est masqué
                decoration: InputDecoration(
                  labelText: "Confirmer le mot de passe",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200], // Couleur du chanp
                  prefixIcon: Icon(Icons.lock), // Icon
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      // Action lorsque l'utilisateur appuie sur l'icône
                      setState(() {
                        // Inverse la visibilité du mot de passe
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
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
                height: 60,
                width: MediaQuery.of(context).size.width * .7,
                child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        // Validation de champ
                        // Appelle la méthode d'inscription de AuthService
                        AuthService()
                            .createAccountWithEmail(
                                _emailController.text, _passwordController.text)
                            .then((value) {
                          // Renvoie un message de réussite et navigue vers Home
                          if (value == "Compte créé avec succès") {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Compte créé avec succès")));
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
                    child: Text(
                      "S'inscrire",
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
                    // Action du button
                    AuthService().continueWithGoogle().then((value) {
                      // Appelle la méthode d'inscription avec google de AuthService
                      // Renvoie un message de réussite et navigue vers Home
                      if (value == "Connexion réussie avec Google") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Connexion réussie avec Google")));
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
                        "images/google.png", // path de l;image
                        height: 30,  // Hauteur
                        width: 30,  // Largeur
                      ),
                      SizedBox(
                        width: 10,
                      ),
                       // Texte sur le bouton
                      Text(
                        "Continuer avec Google.",
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
                Text("Vous avez déjà un compte ?"),
                // Bouton pour naviguer vers la page de connection
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Se Connecter"))
              ],
            )
          ]),
        ),
      ),
    );
  }
}
