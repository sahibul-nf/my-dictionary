import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_dictionary/controller/color.dart';
import 'package:my_dictionary/view/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  final FaIcon icon;
  final Color iconColor;
  final String title;
  final VoidCallback signOutt;

  UserProfilePage({this.signOutt, this.title, this.icon, this.iconColor});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String imageFile = '';
  String username = '';
  String profession = '';
  String gender = '';

  statusLogin sstatusLogin;

  signOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      sharedPreferences.setInt('value', null);
      // ignore: deprecated_member_use
      sharedPreferences.commit();
      sstatusLogin = statusLogin.notSignIn;

      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  getDataPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      imageFile = sharedPreferences.getString('img');
      username = sharedPreferences.getString('username');
      gender = sharedPreferences.getString('gender');
      profession = sharedPreferences.getString('profession');

      print('file : ${sharedPreferences.getString('img')}');
    });
  }

  @override
  void initState() {
    getDataPref();
    // signOut();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(gender);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            color: MyColor().color3,
          ),
          Align(
            alignment: Alignment(0, -0.4),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.25,
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      (username == '') ? 'Here\'s username' : '$username',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.sourceSansPro(
                        color: MyColor().color1,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      (profession == '') ? 'Flutter Developer' : '$profession',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.sourceSansPro(
                        color: Colors.black54,
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
            ),
          ),
          Stack(
            children: [
              Align(
                alignment: Alignment(0, -0.66),
                child: Container(
                  height: 105,
                  width: 105,
                  decoration: BoxDecoration(
                    color: MyColor().color4,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              (gender == 'Male')
                  ? Align(
                      alignment: Alignment(0, -0.64),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          height: 90,
                          width: 90,
                          color: MyColor().color2,
                          child: Image.asset(
                            'images/male.png',
                            height: 90,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    )
                  : (gender == 'Female')
                      ? Align(
                          alignment: Alignment(0, -0.64),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              'images/female.png',
                              height: 90,
                              fit: BoxFit.contain,
                            ),
                          ),
                        )
                      : Icon(Icons.account_circle,
                          size: 105, color: MyColor().color3),
            ],
          ),
          Align(
            alignment: Alignment(0, 0.5),
            child: FlatButton(
              onPressed: () {
                signOut();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: MyColor().color1,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LineIcons.sign_out,
                    color: MyColor().color5,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Sign Out',
                    style: GoogleFonts.sourceSansPro(
                      color: MyColor().color5,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
