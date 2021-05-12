import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_dictionary/controller/color.dart';
import 'package:my_dictionary/view/activity_screen.dart';
import 'package:my_dictionary/view/home_screen.dart';
import 'package:my_dictionary/view/user_profile_screen.dart';
// import 'package:outline_material_icons/outline_material_icons.dart';

class BaseScreen extends StatefulWidget {
  

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  IconData iconn;
  Color colorr;
  
  final List<Widget> allDestinations = [
    HomeScreen(
        title: 'Home',
        icon: FaIcon(FontAwesomeIcons.home),
        iconColor: MyColor().color4),
    ActivityScreen(
        title: 'Activity',
        icon: FaIcon(FontAwesomeIcons.save),
        iconColor: MyColor().color2),
    UserProfilePage(
      title: 'Account',
      icon: FaIcon(FontAwesomeIcons.user),
      iconColor: MyColor().color2,
    ),
  ];

  double iconSize = 30;
  
  int _cIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: allDestinations[_cIndex],
      bottomNavigationBar: Container(
        height: 70,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          child: BottomNavigationBar(
            selectedFontSize: 12,
            backgroundColor: MyColor().color1,
            iconSize: 30,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            unselectedItemColor: MyColor().color2,
            selectedItemColor: MyColor().color4,
            currentIndex: _cIndex,
            items: [
              BottomNavigationBarItem(
                icon: (_cIndex == 0) ? Icon(Icons.home) : Icon(LineIcons.home),
                title: Text('Home',
                    style: GoogleFonts.sourceSansPro(fontSize: 14)),
              ),
              BottomNavigationBarItem(
                icon: (_cIndex == 1)
                    ? Icon(Icons.favorite)
                    : Icon(LineIcons.heart_o),
                title: Text('Activity',
                    style: GoogleFonts.sourceSansPro(fontSize: 14)),
              ),
              BottomNavigationBarItem(
                icon: (_cIndex == 2)
                    ? Icon(Icons.account_circle)
                    : Icon(LineIcons.user),
                title: Text('Account',
                    style: GoogleFonts.sourceSansPro(fontSize: 14)),
              )
            ],
            onTap: (int index) {
              setState(() {
                _cIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
