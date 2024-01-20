import 'package:flutter/material.dart';

class test extends StatefulWidget {
  const test({super.key});

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Text('login'),
        SizedBox(
          height: 10,
          ),

        SizedBox(
          width: MediaQuery.of(context).size.width *.9,
          child: TextFormField
          (
           decoration: InputDecoration(border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(18)
           ),
           label:  Text('Email'),
           prefixIcon: Icon(Icons.email),
           ),
          
           
          ),
        ),
        SizedBox(height: 10,),
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width *.9,
                  child: ElevatedButton(
            onPressed: (){
          
            },
            child: Text('Login'),
          ),
        ),
        SizedBox(height: 10,),
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width *.9,
                  child: ElevatedButton(
            onPressed: (){
          
            },
            
            child: Text('Login'),
          ),
        )
    
    
      ]),
    );
  }
}