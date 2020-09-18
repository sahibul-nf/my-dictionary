import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_dictionary/view/base_screen.dart';
import 'package:my_dictionary/view/home_screen.dart';
import 'package:my_dictionary/view/login_screen.dart';
import 'package:my_dictionary/view/register_screen.dart';
import 'package:my_dictionary/view/splash_screen.dart';
import 'package:my_dictionary/view/user_profile_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/base': (BuildContext context) => BaseScreen(),
        '/login': (BuildContext context) => LoginScreen(),
        '/register': (BuildContext context) => RegisterScreen(),
        '/home': (BuildContext context) => HomeScreen(),
        '/user': (BuildContext context) => UserProfilePage(),
      },
    );
  }
}
