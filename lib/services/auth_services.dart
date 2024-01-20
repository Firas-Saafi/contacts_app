import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // inscription avec email & mot de passe 
  Future<String> createAccountWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
          
      return "Compte créé avec succès";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  // Connection avec email & mot de passe 
  Future<String> loginWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
          
      return "Connexion réussie.";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  // Deconnexion
  Future logout() async {
    await FirebaseAuth.instance.signOut();
    // logout from google if logged in with google
    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().signOut();
    }
  }

  // Vérifier si l'utilisateur est connecté ou non
  Future<bool> isLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  // Connection avec google
  Future<String> continueWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      
      // Envoyer une demande d'authentification

      final GoogleSignInAuthentication gAuth = await googleUser!.authentication;

      // Obtenir les informations d'identification
      final info = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);

      // Se connecter avec les informations d'identification
      await FirebaseAuth.instance.signInWithCredential(info);

      return "Connexion réussie avec Google";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }
}