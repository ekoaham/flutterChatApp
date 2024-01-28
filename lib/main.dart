import 'package:flutter/material.dart';
import 'package:flash_chat_app_flutter/screens/welcome_screen.dart';
import 'package:flash_chat_app_flutter/screens/login_screen.dart';
import 'package:flash_chat_app_flutter/screens/registration_screen.dart';
import 'package:flash_chat_app_flutter/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid? await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyA5aWdyPFqKeCm3Ib89vVKI0EfxtoovdQM',
          appId: '1:488400188941:android:a348b22c973463e5a74744',
          messagingSenderId: '488400188941',
          projectId: 'flash-chat-10168'
      )
  ): await Firebase.initializeApp();
   runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id : (context) => WelcomeScreen(),
        LoginScreen.id : (context) => LoginScreen(),
        RegistrationScreen.id : (context) => RegistrationScreen(),
        ChatScreen.id : (context) => ChatScreen(),
      },
    );
  }
}