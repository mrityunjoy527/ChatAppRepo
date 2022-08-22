import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/services/auth.dart';
import 'package:flutterchat/services/database.dart';

import '../authanticate/helperfunctions.dart';
import '../widgets/widget.dart';
import 'chatRoom.dart';

class SignIn extends StatefulWidget {
  Function toggle;
  SignIn(this.toggle);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  bool _loading = false;
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  QuerySnapshot? querySnapshot;

  signMeIn() {
    if(formKey.currentState?.validate() == true) {
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      setState(() {
        _loading = true;
      });
      querySnapshot = databaseMethods.getUserByUserEmail(emailTextEditingController.text);
      HelperFunctions.saveUserNameSharedPreference(querySnapshot?.docs[0].get("name"));
      authMethods.signInWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((value) {
        if(value != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Connect', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
      ),
      body: _loading? Center(
        child: CircularProgressIndicator(),
      ): Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) {
                          if(val != null) {
                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)? null : "Enter correct email";
                          }
                          return null;
                        },
                        controller: emailTextEditingController,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16
                        ),
                        decoration: textFieldInputDecoration('email'),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val) {
                          if(val != null) {
                            return val.length < 6? "Enter password 6+ characters": null;
                          }
                          return null;
                        },
                        controller: passwordTextEditingController,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        decoration: textFieldInputDecoration('password'),
                      ),
                    ],
                  )
              ),
              SizedBox(height: 8),
              Container(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text(
                    'Forgot Password?', style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16,),
              GestureDetector(
                onTap: () {
                  signMeIn();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff007ef4),
                          Color(0xff2a75bc)
                        ]
                      ),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text(
                    'Sign In', style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                  ),
                ),
              ),
              SizedBox(height: 16,),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)
                ),
                child: Text(
                  'Sign In with Google', style: TextStyle(
                  fontSize: 17,
                  color: Colors.black87,
                ),
                ),
              ),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have account? ", style: TextStyle(
                    color: Colors.white,
                    fontSize: 17
                  ),),
                  GestureDetector(
                    onTap: () {
                      widget.toggle();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('Register now', style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        decoration: TextDecoration.underline,
                      ),),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50,)
            ],
          ),
        ),
      ),
    );
  }
}
