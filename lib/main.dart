import 'package:contacts_app/screens/add_contact_screen.dart';
import 'package:contacts_app/screens/home_screen.dart';
import 'package:contacts_app/screens/login_screen.dart';
import 'package:contacts_app/screens/sign_up_screen.dart';
import 'package:contacts_app/services/auth_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts App',
      theme: ThemeData(
        textTheme: GoogleFonts.soraTextTheme(),
       
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,

      routes: {
        "/": (context) => CheckUser(),
        "/home": (context) => const HomeScreen(),
        "/signup": (context) => SignUpScreen(),
        "/login": (context) => LoginScreen(),
        "/add": (context) => AddContact()
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
  void initState() {
    AuthService().isLoggedIn().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
