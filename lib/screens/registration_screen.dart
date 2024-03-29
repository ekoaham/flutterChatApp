import 'package:flutter/material.dart';
import 'package:flash_chat_app_flutter/components/rounded_button.dart';
import 'package:flash_chat_app_flutter/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_app_flutter/screens/chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = '/third';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool _showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                    color: Colors.blueGrey[400]
                ),
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your email'
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(

                style: TextStyle(
                  color: Colors.blueGrey[400]
                ),
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton('Register', Colors.blueAccent,
                      () async{
                print(email);
                print(password);

                setState(() {
                  _showSpinner = true;
                });

               try{
                 final newUser =await _auth.createUserWithEmailAndPassword(email: email, password: password);
                 if(newUser != Null){
                   Navigator.pushNamed(context, ChatScreen.id);
                 }
               }
               catch(e){
                 print(e);
               }
               setState(() {
                 _showSpinner = false;
               });
                      }
              )
            ],
          ),
        ),
      ),
    );
  }
}

