import 'package:contacts_app/services/firestore_services.dart';
import 'package:flutter/material.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter Contact")),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "images/Contacts.png",
                  height: 120,
                  width: 120,
                ),
                SizedBox(
                  height: 30,
                ) ,     
                SizedBox(
                  width: MediaQuery.of(context).size.width * .9,
                  child: TextFormField(
                    validator: (value) =>
                    value!.isEmpty ? "Veillez remplir le nom" : null,
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      label: Text("Nom"),
                      prefixIcon: Icon(Icons.person),
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
                  height: 65,
                  width: MediaQuery.of(context).size.width * .7,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        CRUD().addNewContacts(_nameController.text,
                          _phoneController.text, _emailController.text);
                          Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "Ajouter",
                      style: TextStyle(fontSize: 16),
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
