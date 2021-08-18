import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_app/AllScreens/loginScreen.dart';
import 'package:ride_app/AllScreens/mainscreen.dart';
import 'package:ride_app/AllWidgets/progresDialog.dart';
import 'package:ride_app/main.dart';

class RegistrationScreen extends StatelessWidget {

  static const String idScreen = "register";

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
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
              SizedBox(height: 1.0,),
              Image(
                image: AssetImage("images/Ngojek.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              SizedBox(height: 1.0,),
              Text(
                "Daftar sebagai Rider",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    SizedBox(height: 1.0,),
                    TextField(
                      // ===== Name =====
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Name",
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

                    SizedBox(height: 1.0,),
                    TextField(
                      // ===== No.Telp =====
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "No.Telp",
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

                    SizedBox(height: 20.0,),
                    RaisedButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Buat Akun",
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                      onPressed: ()
                      {
                        if (nameTextEditingController.text.length < 3) {
                            displayToastMessage("Name yang anda masukan harus terdiri 3 Characters.", context);
                        }
                        else if(!emailTextEditingController.text.contains("@"))
                        {
                            displayToastMessage("Email yang anda masukan salah.", context);
                        }
                        else if(phoneTextEditingController.text.isEmpty)
                        {
                          displayToastMessage("No.Telp yang anda masukan salah.", context);
                        }
                        else if(passwordTextEditingController.text.length < 6)
                        {
                          displayToastMessage("Password yang anda masukan harus terdiri 3 characters.", context);
                        }
                        else
                          {
                            registerNewUser(context);
                          }
                      },
                    ),


                  ],
                ),
              ),

              FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Tidak punya Akun? Daftar disini",

                ),
              ),

            ],
          ),
        ),
      ),
    );
  }


  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async
  {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return ProgressDialog(message: "Registrasi, Please Wait...",);
        }
    );

    final User? firebaseUser = (await _firebaseAuth
        .createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text
    ).catchError((errMsg){
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    })).user;


    if(firebaseUser != null)
    {
      //  Simpan user database


      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      usersRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage("Selamat akun anda berhasil dibuat.", context);
      
      
      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
      }
    else
      {
        Navigator.pop(context);
        displayToastMessage("User akun tidak dapat dibuat.", context);
      //  error pemberitahuan
    }
  }
}

displayToastMessage(String message, BuildContext context)
  {
    Fluttertoast.showToast(msg: message);
  }

