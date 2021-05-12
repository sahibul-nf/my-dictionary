import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_dictionary/controller/color.dart';
import 'package:my_dictionary/view/base_screen.dart';
// import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

enum statusLogin { signIn, notSignIn }

class _LoginScreenState extends State<LoginScreen> {
  final _keyForm = GlobalKey<FormState>();

  statusLogin _loginStatus = statusLogin.notSignIn;

  bool securer = false;
  Icon iconSecure = Icon(LineIcons.eye, color: Colors.indigo[100]);

  String usernameN, passwordN;

  // cek ketika menekan tombol login
  checkForm() {
    final form = _keyForm.currentState;
    if (form.validate()) {
      form.save();
      submitDataLogin();
    }
  }

  // mengirim request dan menanggapinya
  submitDataLogin() async {
    String urlAPI = 'https://40c17614ccd1.ngrok.io/my-dictionary-server/login.php';
    final apiResult = await http.post(
      urlAPI,
      body: {'username': usernameN, 'password': passwordN},
    );

    final data = jsonDecode(apiResult.body);

    int value = data['value'];
    String msg = data['msg'];

    print(data);

    // get data respon
    String dataUsername = data['username'];
    String dataEmail = data['email'];
    String dataAddress = data['address'];
    String dataGender = data['gender'];
    String dataFullName = data['full_name'];
    String dataCreatedAt = data['createdAt'];
    String dataIdUser = data['id_user'];
    String dataProfession = data['profession'];

    // cek value 1 atau 0 atau 2
    if (value == 1) {
      setState(() {
        // set status login menjadi login
        _loginStatus = statusLogin.signIn;

        // simpan data ke share preferends
        saveDataPref(value, dataIdUser, dataUsername, dataEmail, dataAddress,
            dataGender, dataFullName, dataCreatedAt, dataProfession);
      });
    } else {
      Flushbar(
        backgroundColor: Colors.pink[300],
        padding: EdgeInsets.only(left: 24, top: 16, bottom: 16),
        icon: Icon(Icons.warning),
        messageText: Text('$msg  $value',
            style: GoogleFonts.sourceSansPro(
                color: MyColor().color5, fontSize: 16)),
        duration: Duration(seconds: 3),
      ).show(context);
    }
  }

  saveDataPref(int value, String idUser, username, email, address, gender,
      fullName, createdAt, profession) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      sharedPreferences.setInt('value', value);
      sharedPreferences.setString('username', username);
      sharedPreferences.setString('full_name', fullName);
      sharedPreferences.setString('email', email);
      sharedPreferences.setString('gender', gender);
      sharedPreferences.setString('createdAt', createdAt);
      sharedPreferences.setString('id_user', idUser);
      sharedPreferences.setString('profession', profession);
    });
  }

  // fungsi untuk cek user login atau belum
  getDataPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      int valueN = sharedPreferences.getInt('value');
      _loginStatus = valueN == 1 ? statusLogin.signIn : statusLogin.notSignIn;

      print('id : ${sharedPreferences.getString('id_user')}');
      print('username : ${sharedPreferences.getString('username')}');
    });
  }

  @override
  void initState() {
    getDataPref();
    super.initState();
  }

  // fungsi untuk signOut
  signOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      sharedPreferences.setInt('value', null);
      // ignore: deprecated_member_use
      sharedPreferences.commit();
      _loginStatus = statusLogin.notSignIn;
    });
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    print(_loginStatus);
    switch (_loginStatus) {
      case statusLogin.notSignIn:
        return Scaffold(
          backgroundColor: MyColor().color2,
          appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: MyColor().color2,
              toolbarHeight: 80,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: SafeArea(
                  child: Image.asset(
                    'images/logo_hi_blue.png',
                    height: 50,
                  ),
                ),
              )),
          body: Form(
            key: _keyForm,
            child: Container(
              padding: EdgeInsets.fromLTRB(24, 70, 24, 0),
              decoration: BoxDecoration(
                  color: MyColor().color5,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30))),
              child: ListView(
                children: [
                  Text('Welcome \nBack Explorer!',
                      style: GoogleFonts.montserrat(
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87)),
                  SizedBox(
                    height: 54,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    child: TextFormField(
                      // controller: usernameC,
                      validator: (value) =>
                          (value.isEmpty) ? 'Please input your username' : null,
                      onSaved: (value) => usernameN = value,
                      cursorColor: Colors.indigo[100],
                      style: GoogleFonts.sourceSansPro(
                          color: MyColor().color1,
                          decoration: TextDecoration.none),
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            LineIcons.user,
                            color: MyColor().color2,
                          ),
                          hintText: 'Your Username',
                          hintStyle: GoogleFonts.sourceSansPro(
                              color: Colors.indigo[100]),
                          labelText: 'Username',
                          labelStyle: TextStyle(color: Colors.indigo[100]),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.pink),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.pink),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.indigo[100]),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: MyColor().color2),
                              borderRadius: BorderRadius.circular(8))),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    child: TextFormField(
                      // controller: passwordC,
                      validator: (value) => (value.isEmpty)
                          ? 'Please input your password'
                          : (value.length < 6)
                              ? 'Password length min 6 character'
                              : null,
                      onSaved: (value) => passwordN = value,
                      onTap: () {
                        if (securer == true) {
                          setState(() {
                            securer = false;
                            iconSecure = Icon(LineIcons.eye_slash,
                                color: Colors.indigo[100]);
                          });
                        } else {
                          setState(() {
                            securer = true;
                            iconSecure = Icon(LineIcons.eye,
                                color: Colors.indigo[100]);
                          });
                        }
                      },
                      obscureText: securer,
                      cursorColor: Colors.indigo[100],
                      style: GoogleFonts.sourceSansPro(
                          color: MyColor().color1,
                          decoration: TextDecoration.none),
                      decoration: InputDecoration(
                          suffixIcon: iconSecure,
                          prefixIcon: Icon(
                            LineIcons.lock,
                            color: MyColor().color2,
                          ),
                          hintText: 'Your Password',
                          hintStyle: GoogleFonts.sourceSansPro(
                              color: Colors.indigo[100]),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.indigo[100]),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.pink),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.pink),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.indigo[100]),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: MyColor().color2),
                              borderRadius: BorderRadius.circular(8))),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(top: 8),
                    child: Text(
                      'Forgot password?',
                      style: GoogleFonts.sourceSansPro(
                          fontWeight: FontWeight.w300, color: Colors.black54),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 40, bottom: 70),
                    child: FloatingActionButton(
                        elevation: 0,
                        backgroundColor: MyColor().color3,
                        splashColor: Colors.deepPurple[200],
                        child: Icon(Icons.arrow_forward),
                        onPressed: () {
                          setState(() {
                            checkForm();
                          });
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Start fresh now? ',
                          style: GoogleFonts.sourceSansPro(
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              color: Colors.black54)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text('Sign Up',
                            style: GoogleFonts.sourceSansPro(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: MyColor().color2)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
        break;
      case statusLogin.signIn:
        return BaseScreen();
        break;
    }
  }
}