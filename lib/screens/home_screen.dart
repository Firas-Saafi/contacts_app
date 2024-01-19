import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_app/screens/update_contact_screen.dart';
import 'package:contacts_app/services/auth_services.dart';
import 'package:contacts_app/services/firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stream<QuerySnapshot> _stream;
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchfocusNode = FocusNode();

  @override
  void initState() {
    _stream = CRUD().getContacts();
    super.initState();
  }

  @override
  void dispose() {
    _searchfocusNode.dispose();
    super.dispose();
  }

  // to call the contact using url launcher
 call(String phone) async {
  String url = "tel:$phone";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw "Could not launch $url";
  }
}


sendMessage(String phone) async {
  String url = "sms:$phone";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw "Could not launch $url";
  }
}

  // search Function to perform search

  searchContacts(String search) {
    _stream = CRUD().getContacts(searchQuery: search);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Contacts"),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/add");
            },
            child: Icon(Icons.person_add),
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              elevation: 0, 
            ),
          ),
        ],
      ),
       // barre de Recherche
      bottom: PreferredSize(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .9,
            child: TextFormField(
              onChanged: (value) {
                searchContacts(value);
                setState(() {});
              },
              focusNode: _searchfocusNode,
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                label: Text("Recherche"),
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    _searchfocusNode.unfocus();
                    _stream = CRUD().getContacts();
                    setState(() {});
                  },
                  icon: Icon(Icons.close),
                )
                : null
              ),
            )
          ),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width * 8, 80)),
      ),
      
      drawer: Drawer(
          child: ListView(
        children: [
          DrawerHeader(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              CircleAvatar(
                maxRadius: 40,
                backgroundColor: Colors.blue,
                child: Text(FirebaseAuth.instance.currentUser!.email
                    .toString()[0]
                    .toUpperCase(),
                    style: TextStyle(
                    fontSize: 32, 
                    fontWeight: FontWeight.bold,
                   
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(FirebaseAuth.instance.currentUser!.email.toString(),
              style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
              ),)
            ],
          )),
          ListTile(
            onTap: () {
              AuthService().logout();
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Deconnecter")));
              Navigator.pushReplacementNamed(context, "/login");
            },
            leading: Icon(Icons.logout_outlined),
            title: Text("Se Deconnecter"),
          )
        ],
      )),
      body: StreamBuilder<QuerySnapshot>(
          stream: _stream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something Went Wrong");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Chargement..."),
              );
            }
            return snapshot.data!.docs.length == 0
                ? Center(
                    child: Text("Aucun Contact ..."),
                  )
                : ListView(
                  children: snapshot.data!.docs
                  .map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                    return Card(
                      color: Colors.blue[50], 
                      elevation: 3, 
                      margin: EdgeInsets.all(8), 
                      child: ListTile(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateContact(
                              name: data["name"],
                              phone: data["phone"],
                              email: data["email"],
                              docID: document.id,
                            ),
                          ),
                        ),
                        leading: CircleAvatar(
                          child: Text(data["name"][0].toUpperCase()),
                          backgroundColor: Colors.blue[400],
                        ),
                        title: Text(
                        data["name"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(data["phone"]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.message),
                            color: Colors.blue,
                            onPressed: () {
                              sendMessage(data["phone"]);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.call),
                            color: Colors.green,
                            onPressed: () {
                              call(data["phone"]);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
              )
              .toList()
              .cast(),
          );
        },
      ),
    );
  }
}



/*  trailing: PopupMenuButton<String>(
  icon: Icon(Icons.more_vert), 
  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
    PopupMenuItem<String>(
      value: 'message',
      child: Row(
        children: [
          Icon(Icons.message, color: Colors.blue),
          SizedBox(width: 8),
          Text('Message'),
        ],
      ),
    ),

    PopupMenuItem<String>(
      value: 'call',
      child: Row(
        children: [
          Icon(Icons.call, color: Colors.green),
          SizedBox(width: 8),
          Text('Appler'),
        ],
      ),
    ),
  ],
  onSelected: (String action) {
    if (action == 'message') {
      sendMessage(data["phone"]);
    } else if (action == 'call') {
      call(data["phone"]);
    }
  },
), */