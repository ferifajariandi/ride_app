import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ride_app/AllScreens/mainscreen.dart';
import 'package:ride_app/AllScreens/registrationScreen.dart';
import 'package:ride_app/AllWidgets/progresDialog.dart';

import '../main.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "Login";
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 35.0,),
              Image(
                image: AssetImage("images/Ngojek.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),

              SizedBox(height: 1.0),
              Padding(
                  padding: EdgeInsets.only(top: 0)
              ),
              Text(
                "Selamat datang di Ngojek!",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    SizedBox(height: 1.0,),
                    TextField(
                      // ===== Email =====
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),


                    //  ==== password =====
                    SizedBox(height: 1.0,),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 25.0,),
                    RaisedButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                      onPressed: () {
                        if(!emailTextEditingController.text.contains("@"))
                        {
                          displayToastMessage("Email yang anda masukan salah.", context);
                        }
                        else if(passwordTextEditingController.text.isEmpty)
                        {
                          displayToastMessage("Password wajib diisi.", context);
                        }
                        else
                          {
                            loginAndAuthenticateUser(context);
                          }
                      },
                    ),


                  ],
                ),
              ),

              FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RegistrationScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Tidak punya Akun? Daftar disini",

                ),
              )

            ],
          ),
        ),
      ),
    );
  }


  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    void loginAndAuthenticateUser(BuildContext context) async
    {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return ProgressDialog(message: "Authenticating, Please Wait...",);
        }
      );

      final User? firebaseUser = (await _firebaseAuth
          .signInWithEmailAndPassword(
          email: emailTextEditingController.text,
          password: passwordTextEditingController.text
      ).catchError((errMsg){
        Navigator.pop(context);
        displayToastMessage("Error: " + errMsg.toString(), context);
      })).user;

      if(firebaseUser != null)
      {
        usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap){
          if(snap.value != null)
            {
              Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
              displayToastMessage("Selamat anda berhasil masuk.", context);
            }
          else {
            Navigator.pop(context);
            _firebaseAuth.signOut();
            displayToastMessage("Tidak ada data tersimpan untuk user ini. Tolong buat akun lagi.", context);
          }
        });

      }
      else
      {
        Navigator.pop(context);
        displayToastMessage("Erorr! tidak dapat masuk ke akun.", context);
        //  error pemberitahuan
      }
    }
}
