import 'package:flutter/material.dart';
import 'package:flutterchat/authanticate/helperfunctions.dart';
import 'package:flutterchat/services/database.dart';

import '../services/auth.dart';
import '../widgets/widget.dart';
import 'package:flutter/cupertino.dart';

import 'chatRoom.dart';

class SignUp extends StatefulWidget {
  Function toggle;
  SignUp(this.toggle);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  bool _loading = false;
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  signMeUp() {
    if(formKey.currentState?.validate() == true) {
      Map<String, String> userMap = {"name": userNameTextEditingController.text, "email": emailTextEditingController.text};
      HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      setState(() {
        _loading = true;
      });
      authMethods.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((value) {
        // print(value);
        databaseMethods.uploadUserInfo(userMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Connect', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
      ),
      body: _loading? const Center(
        child: CircularProgressIndicator()
      ): Container(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: userNameTextEditingController,
                        validator: (val) {
                          if(val != null) {
                            return val.isEmpty || val.length < 4 ? "Please provide userName" : null;
                          }
                          return null;
                        },
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16
                        ),
                        decoration: textFieldInputDecoration('user'),
                      ),
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
                  ),
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
                    signMeUp();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [
                              Color(0xff007ef4),
                              Color(0xff2a75bc)
                            ]
                        ),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: const Text(
                      'Sign Up', style: TextStyle(
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
                    'Sign Up with Google', style: TextStyle(
                    fontSize: 17,
                    color: Colors.black87,
                  ),
                  ),
                ),
                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have account? ", style: TextStyle(
                        color: Colors.white,
                        fontSize: 17
                    ),),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('SignIn Now', style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            decoration: TextDecoration.underline
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
      ),
    );
  }
}
