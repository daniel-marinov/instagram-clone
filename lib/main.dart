// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/providers/user_provider.dart';
import 'package:task_app/responsive/mobile_screen_layout.dart';
import 'package:task_app/responsive/responsive_layout_screen.dart';
import 'package:task_app/responsive/web_screen_layout.dart';
import 'package:task_app/screens/login_screen.dart';
import 'package:task_app/screens/sign_up_screen.dart';
import 'package:task_app/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //this is done becouse for the web we need the options parameter, but with
  // the options parameter it wont work for mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBl9GE0WQebSFfWeOLlYzYqVz3EmKNB2AI",
            appId: "1:503605260519:web:ce1c73c887f8791a0bf242",
            messagingSenderId: "503605260519",
            projectId: "instagram-clone-2ebb0",
            //optional parameter storage bucket
            storageBucket: "instagram-clone-2ebb0.appspot.com"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Instagram Clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  webScreenLayout: WebScreenLayout(),
                  mobileScreenLayout: MobileScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}

//remove com.example from android manifest file later whe nuploading to play store