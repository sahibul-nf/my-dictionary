import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_dictionary/controller/color.dart';

class ActivityScreen extends StatefulWidget {
  final FaIcon icon;
  final Color iconColor;
  final String title;

  ActivityScreen({this.title, this.icon, this.iconColor});

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().color5,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Coming soon..',
              style: GoogleFonts.sourceSansPro(
                color: Colors.indigo[100],
                fontWeight: FontWeight.w300,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Image.asset(
              'images/undraw_empty_xct9.png',
              height: MediaQuery.of(context).size.height * 0.3,
            )
          ],
        ),
      ),
    );
  }
}
