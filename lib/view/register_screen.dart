import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_dictionary/controller/color.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _keyForm = GlobalKey<FormState>();

  bool securer = false;
  Icon iconSecure = Icon(OMIcons.visibility, color: Colors.indigo[100]);

  var usernameC = TextEditingController();
  var fullNameC = TextEditingController();
  var emailC = TextEditingController();
  var passwordC = TextEditingController();
  var addressC = TextEditingController();

  String usernameN, fullNameN, emailN, passwordN, addressN;
  String genderN = '';
  File imageFile;
  // File image;
  // String status = '';
  // String base64Image;
  // String errMsg = 'Error Uploading Image';

  setDataPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      sharedPreferences.setString('img', imageFile.toString());
    });
  }

  void selectGender(String value) {
    setState(() {
      genderN = value;
    });
  }

  checkForm() {
    final form = _keyForm.currentState;
    if (form.validate()) {
      form.save();
      submitDataRegister();
    }
  }

  Future getImage(ImgSource source) async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: source,
      cameraIcon: Icon(
        Icons.add_a_photo,
        color: MyColor().color3,
      ),
    );

    setState(() {
      imageFile = image;
      // print('Image $imageFile');
    });
  }

  Future<Timer> startTimer() async {
    return Timer(Duration(seconds: 3), timerDone);
  }

  void timerDone() {
    Navigator.pushReplacementNamed(context, '/login');
    // Navigator.pop(context);
  }

  submitDataRegister() async {
    String urlAPI = 'http://192.168.43.208/my-dictionary-server/register.php';
    final apiResult = await http.post(urlAPI, body: {
      'username': usernameN,
      'full_name': fullNameN,
      'email': emailN,
      'password': passwordN,
      'address': addressN,
      'gender': genderN,
    });

    final data = jsonDecode(apiResult.body);

    int value = data['value'];
    String msg = data['msg'];

    if (value == 1) {
      setState(() {
        successRegister(msg);
      });
    } else if (value == 2) {
      setState(() {
        Flushbar(
          backgroundColor: MyColor().color3,
          padding: EdgeInsets.only(left: 24, top: 16, bottom: 16),
          icon: Icon(Icons.warning),
          messageText: Text(msg,
              style: GoogleFonts.sourceSansPro(
                  color: MyColor().color1, fontSize: 16)),
          duration: Duration(seconds: 3),
        ).show(context);
      });
    } else {
      Flushbar(
        backgroundColor: Colors.pink,
        padding: EdgeInsets.only(left: 24, top: 16, bottom: 16),
        icon: Icon(Icons.warning),
        title: 'Failed to register',
        messageText: Text(msg,
            style: GoogleFonts.sourceSansPro(
                color: MyColor().color5, fontSize: 16)),
        duration: Duration(seconds: 3),
      ).show(context);
    }
  }

  bool selected = false;

  successRegister(String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            content: Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: FlareActor(
                      'images/Success Check.flr',
                      animation: 'Untitled',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sourceSansPro(
                      color: Color(0xff00ca71),
                      fontWeight: FontWeight.w500,
                      fontSize: 32,
                    ),
                  ),
                  Text(
                    '$msg',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sourceSansPro(
                      color: Colors.black38,
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
          );
        });
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().color2,
      appBar: AppBar(
        backgroundColor: MyColor().color2,
        toolbarHeight: 80,
        elevation: 0,
        centerTitle: true,
        title: Text('Create \nYour Account',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.normal, color: MyColor().color5)),
      ),
      body: Form(
        key: _keyForm,
        child: Container(
          padding: EdgeInsets.fromLTRB(24, 50, 24, 0),
          decoration: BoxDecoration(
              color: MyColor().color5,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30))),
          child: ListView(
            children: [
              Container(
                // color: Colors.red,
                height: 120,
                child: (imageFile == null)
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                              backgroundColor: MyColor().color4,
                              radius: 45,
                              child: Icon(Icons.account_circle,
                                  size: 90, color: MyColor().color3)),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: GestureDetector(
                              onTap: () => getImage(ImgSource.Both),
                              child: CircleAvatar(
                                backgroundColor: MyColor().color2,
                                radius: 15,
                                child: Icon(Icons.add_circle_outline,
                                    size: 30, color: MyColor().color5),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 105,
                            width: 105,
                            decoration: BoxDecoration(
                              color: MyColor().color4,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.file(
                              imageFile,
                              height: 90,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  imageFile = null;
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.pink,
                                radius: 15,
                                child: Icon(OMIcons.cancel,
                                    size: 30, color: MyColor().color5),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              SizedBox(
                height: 24,
              ),

              Container(
                margin: EdgeInsets.only(top: 16),
                child: TextFormField(
                  controller: fullNameC,
                  validator: (value) =>
                      (value.isEmpty) ? 'Please input your name' : null,
                  onSaved: (value) => fullNameN = fullNameC.text,
                  cursorColor: Colors.indigo[100],
                  style: GoogleFonts.sourceSansPro(
                      color: MyColor().color1, decoration: TextDecoration.none),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        OMIcons.personOutline,
                        color: MyColor().color2,
                      ),
                      hintText: 'Your Name',
                      hintStyle:
                          GoogleFonts.sourceSansPro(color: Colors.indigo[100]),
                      labelText: 'Full Name',
                      labelStyle: TextStyle(color: Colors.indigo[100]),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.pink),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.pink),
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
                  controller: usernameC,
                  validator: (value) =>
                      (value.isEmpty) ? 'Please input your username' : null,
                  onSaved: (value) => usernameN = usernameC.text,
                  cursorColor: Colors.indigo[100],
                  style: GoogleFonts.sourceSansPro(
                      color: MyColor().color1, decoration: TextDecoration.none),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        OMIcons.accountCircle,
                        color: MyColor().color2,
                      ),
                      hintText: 'Your Username',
                      hintStyle:
                          GoogleFonts.sourceSansPro(color: Colors.indigo[100]),
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Colors.indigo[100]),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.pink),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.pink),
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
                  controller: emailC,
                  // autovalidate: true,
                  validator: (value) => (value.isEmpty)
                      ? 'Please input your email'
                      : (!value.endsWith('@gmail.com'))
                          ? 'Email invalid'
                          : null,
                  onSaved: (value) => emailN = emailC.text,
                  cursorColor: Colors.indigo[100],
                  style: GoogleFonts.sourceSansPro(
                      color: MyColor().color1, decoration: TextDecoration.none),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        OMIcons.email,
                        color: MyColor().color2,
                      ),
                      hintText: 'Your Email',
                      hintStyle:
                          GoogleFonts.sourceSansPro(color: Colors.indigo[100]),
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.indigo[100]),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.pink),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.pink),
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
                  controller: passwordC,
                  validator: (value) => (value.isEmpty)
                      ? 'Please input your password'
                      : (value.length < 6)
                          ? 'Password length min 6 character'
                          : null,
                  onSaved: (value) => passwordN = passwordC.text,
                  onTap: () {
                    if (securer == true) {
                      setState(() {
                        securer = false;
                        iconSecure = Icon(OMIcons.visibilityOff,
                            color: Colors.indigo[100]);
                      });
                    } else {
                      setState(() {
                        securer = true;
                        iconSecure =
                            Icon(OMIcons.visibility, color: Colors.indigo[100]);
                      });
                    }
                  },
                  obscureText: securer,
                  cursorColor: Colors.indigo[100],
                  style: GoogleFonts.sourceSansPro(
                      color: MyColor().color1, decoration: TextDecoration.none),
                  decoration: InputDecoration(
                      suffixIcon: iconSecure,
                      prefixIcon: Icon(
                        OMIcons.lock,
                        color: MyColor().color2,
                      ),
                      hintText: 'Your Password',
                      hintStyle:
                          GoogleFonts.sourceSansPro(color: Colors.indigo[100]),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.indigo[100]),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.pink),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.pink),
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
                  controller: addressC,
                  maxLines: 3,
                  validator: (value) =>
                      (value.isEmpty) ? 'Please input your address' : null,
                  onSaved: (value) => addressN = addressC.text,
                  cursorColor: Colors.indigo[100],
                  style: GoogleFonts.sourceSansPro(
                      color: MyColor().color1, decoration: TextDecoration.none),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        OMIcons.place,
                        color: MyColor().color2,
                      ),
                      hintText: 'Your Address',
                      hintStyle:
                          GoogleFonts.sourceSansPro(color: Colors.indigo[100]),
                      labelText: 'Address',
                      labelStyle: TextStyle(color: Colors.indigo[100]),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.pink),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.pink),
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

              // radio button for select gender
              Container(
                margin: EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                    color: MyColor().color5,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Colors.indigo[100])),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 16, 0, 4),
                      child: Row(
                        children: [
                          Icon(LineIcons.mars, color: MyColor().color2),
                          SizedBox(width: 14),
                          Text(
                            'Gender',
                            style: GoogleFonts.sourceSansPro(
                                fontSize: 16, color: Colors.indigo[100]),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: RadioListTile(
                            value: "Male",
                            title: Text('Male'),
                            groupValue: genderN,
                            onChanged: (value) => selectGender(value),
                            activeColor: MyColor().color2,
                            selected: (genderN == 'Male')
                                ? selected = true
                                : selected = false,
                          ),
                        ),
                        Flexible(
                          child: RadioListTile(
                            value: "Female",
                            title: Text('Female'),
                            groupValue: genderN,
                            onChanged: (value) => selectGender(value),
                            activeColor: MyColor().color2,
                            selected: (genderN == 'Female')
                                ? selected = true
                                : selected = false,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 40, bottom: 70),
                child: FloatingActionButton(
                  elevation: 0,
                  backgroundColor: MyColor().color3,
                  splashColor: MyColor().color2,
                  child: Icon(Icons.arrow_forward),
                  onPressed: () {
                    setState(() {
                      checkForm();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
