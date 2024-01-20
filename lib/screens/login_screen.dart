import 'package:contacts_app/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(children: [
            SizedBox(
              height: 120,
            ),
            Image.asset(
              "images/Contacts.png",
                height: 120,
                width: 120,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Se Connecter",
              style:
                  GoogleFonts.sora(fontSize: 32, fontWeight: FontWeight.w700),
            ),
            
            SizedBox(
              height: 20,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? "L'e-mail ne peut pas être vide." : null,
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200], 
                    label: Text("Email"),
                    prefixIcon: Icon(Icons.email),
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextFormField(
              validator: (value) =>
                  value!.length < 8 ? "Le mot de passe doit au moins 8 caractères." : null,
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
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
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark, 
                  ),
                  onPressed: () {
                    setState(() {
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
                height: 60,
                width: MediaQuery.of(context).size.width * .7,
                child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        AuthService()
                            .loginWithEmail(
                                _emailController.text, _passwordController.text)
                            .then((value) {
                          if (value == "Connexion réussie.") {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Connexion réussie")));
                            Navigator.pushReplacementNamed(context, "/home");
                          } else {
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
                    AuthService().continueWithGoogle().then((value) {
                      if (value == "Connexion réussie avec Google") {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Connexion réussie avec Google")));
                        Navigator.pushReplacementNamed(context, "/home");
                      } else {
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
                      Image.asset(
                        "images/google.png",
                        height: 30,
                        width: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Vous n'avez pas de compte ?"),
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
