import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_dictionary/controller/color.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  Future<Timer> startTimer() async {
    return Timer(Duration(seconds: 3), timerDone);
  }

  void timerDone() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().color2,
      body: Center(
        child: Column(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                    // color: color1,
                    child: Image.asset('images/logo_hi_blue.png',
                        height: 100, width: 100))),
            // SizedBox(height: 200),
            Expanded(
              child: Container(
                // color: color3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('from',
                        style: GoogleFonts.sourceSansPro(
                          fontWeight: FontWeight.w400,
                            fontSize: 20, color: Colors.white60)),
                    SizedBox(height: 6),
                    Text(
                      'Sahibul NF',
                      style:
                          GoogleFonts.montserratAlternates(
                            fontWeight: FontWeight.w500,
                            fontSize: 24, color: MyColor().color5),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
