import 'package:contacts_app/services/firestore_services.dart';
import 'package:flutter/material.dart';

class UpdateContact extends StatefulWidget {
  const UpdateContact(
      {super.key,
      required this.docID,
      required this.name,
      required this.phone,
      required this.email});
  final String docID, name, phone, email;

  @override
  State<UpdateContact> createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateContact> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController.text = widget.email;
    _phoneController.text = widget.phone;
    _nameController.text = widget.name;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mettre à jour le Contact")),
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
                          value!.isEmpty ? "Veuillez saisir le nom" : null,
                      controller: _nameController,
                      decoration: InputDecoration(
                        
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        label: Text("Nom"),
                        prefixIcon: Icon(Icons.person),
                      ),
                    )),
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
                    )),
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
                        prefixIcon: Icon(Icons.email),
                      ),
                    )),
                SizedBox(
                  height: 36,
                ),
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * .5,
                  child: ElevatedButton(
                    onPressed: () {
                      // Confirmation dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirmation"),
                            content: Text("Voulez-vous vraiment modifier ce contact?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); 
                                },
                                child: Text("Annuler"),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    CRUD().updateContact(
                                      _nameController.text,
                                      _phoneController.text,
                                      _emailController.text,
                                      widget.docID,
                                    );
                                    Navigator.popUntil(context, ModalRoute.withName('/home'));
                                  }
                                },
                                child: Text(
                                  "valider",
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      "Modifier",
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
                      // Confirmation dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirmation"),
                            content: Text("Voulez-vous supprimer ce contact?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); 
                                },
                                child: Text("Annuler"),
                              ),
                              TextButton(
                                onPressed: () {
                                  CRUD().deleteContact(widget.docID);
                                  Navigator.pop(context);
                                  Navigator.pop(context); 
                                },
                                child: Text(
                                  "Supprimer",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      "Supprimer",
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
