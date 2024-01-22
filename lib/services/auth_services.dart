import 'package:firebase_auth/firebase_auth.dart';  // Bibliothèque pour gérer l'authentification avec Firebase
import 'package:google_sign_in/google_sign_in.dart';  // Bibliothèque pour gérer l'authentification avec Google


class AuthService {  // Classe responsable de la gestion des services d'authentification

  // Inscription avec email et mot de passe
  Future<String> createAccountWithEmail(String email, String password) async {
    try {
      // Utilise Firebase Auth pour créer un compte avec email et mot de passe
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
          
      return "Compte créé avec succès";  // Renvoie un message de réussite
    } on FirebaseAuthException catch (e) {
      return e.message.toString();  // En cas d'erreur, renvoie un message d'erreur
    }
  }

  // Connexion avec email et mot de passe
  Future<String> loginWithEmail(String email, String password) async {
    try {
      // Utilise Firebase Auth pour connecter avec email et mot de passe
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
          
      return "Connexion réussie.";  // Renvoie un message de réussite
    } on FirebaseAuthException catch (e) {
      return e.message.toString();  // En cas d'erreur, renvoie un message d'erreur
    }
  }

  // Déconnexion
  Future logout() async {
    await FirebaseAuth.instance.signOut(); // Déconnecte l'utilisateur
    
    if (await GoogleSignIn().isSignedIn()) { 
      await GoogleSignIn().signOut();    // Déconnecte s'il est connecté avec Google
    }
  }

 // Vérifie si l'utilisateur est connecté ou non
  Future<bool> isLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;   // Obtient l'utilisateur actuel de Firebase Auth
    return user != null;
  }

  // Connexion avec Google
  Future<String> continueWithGoogle() async {

     // Utilise Google Sign-In pour obtenir le compte Google de l'utilisateur
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      

      final GoogleSignInAuthentication gAuth = await googleUser!.authentication;  // Envoyer une demande d'authentification avec Google

      final info = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);  // Obtient les informations d'authentification Google

      
      await FirebaseAuth.instance.signInWithCredential(info);  // Connecte l'utilisateur avec les informations d'authentification Google

      return "Connexion réussie avec Google";  // Renvoie un message de réussite
    } on FirebaseAuthException catch (e) {
      return e.message.toString();  // En cas d'erreur, renvoie un message d'erreur
    }
  }
}