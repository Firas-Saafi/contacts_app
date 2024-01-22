import 'package:flutter/material.dart';  // Importe le package Flutter
import 'package:contacts_app/screens/add_contact_screen.dart';   // Importe la page d'ajout de contact
import 'package:contacts_app/screens/home_screen.dart';  // Importe la pgae Home
import 'package:contacts_app/screens/login_screen.dart';  // Importe la page de connexion
import 'package:contacts_app/screens/sign_up_screen.dart';  // Importe la page d'inscription
import 'package:contacts_app/services/auth_services.dart';  // Importe les services d'authentification
import 'package:firebase_core/firebase_core.dart';  // Importe le package Firebase Core
import 'package:google_fonts/google_fonts.dart'; // Importe les polices Google Fonts
import 'firebase_options.dart';  // Importe le ficher de configuration Firebase

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   // Initialisation de Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Lancement de l'application
  runApp(const MyApp());
}

// class de l'application 
class MyApp extends StatelessWidget {
  const MyApp({super.key});  // Constructeur

 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts App',  // Titre dde l'application
      // Thème de l'application
      theme: ThemeData(  
        textTheme: GoogleFonts.soraTextTheme(),
       
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,  // Désactivation de la bannière de mode debug

      // Routes de navigation
      routes: {
        "/": (context) => CheckUser(),  // vérification de l'utilisateur
        "/home": (context) => const HomeScreen(),   // Route vers page Home
        "/signup": (context) => SignUpScreen(),   // Route vers page d'inscription
        "/login": (context) => LoginScreen(),  // Route vers page de connexion
        "/add": (context) => AddContact()    // Route vers page d'ajout de contact
      },  
    );
  }
}

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}
// Verification de Session   'if user logged in or not'
class _CheckUserState extends State<CheckUser> {
  @override
  // Méthode appelée lors de la création de l'état
  void initState() {
    // Vérification si l'utilisateur est connecté
    AuthService().isLoggedIn().then((value) {
       // Redirection vers la page d'accueil si l'utilisateur est connecté
      if (value) {
        Navigator.pushReplacementNamed(context, "/home");
        // Redirection vers la page de connexion si l'utilisateur n'est pas connecté
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Affichage d'un indicateur de chargement au cours de la vérification
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
