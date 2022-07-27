import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market_cebimde/functions/modern_alert.dart';
import 'package:market_cebimde/screens/LoginAndRegister/LoginPage.dart';

class RegisterPage extends StatelessWidget {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _verifyPasswordController = TextEditingController();
  FocusNode _nameFocus = FocusNode();
  FocusNode _surNameFocus = FocusNode();
  FocusNode _emailFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  FocusNode _verifyPasswordFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/Logo.png", height: 200, width: 250, fit: BoxFit.cover),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text("Kayıt Ol", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: "Montserrat")),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("Ad:", style: TextStyle(fontSize: 18, fontFamily: "Montserrat")),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, right: 10,),
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: "Ad",
                            labelStyle: TextStyle(fontSize: 18, fontFamily: "Montserrat"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          focusNode: _nameFocus,
                          textInputAction: TextInputAction.go,
                          onFieldSubmitted: (value) {
                            _surNameFocus.requestFocus();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("Soyad:", style: TextStyle(fontSize: 18, fontFamily: "Montserrat")),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: TextFormField(
                          controller: _surNameController,
                          decoration: InputDecoration(
                            labelText: "Soyad",
                            labelStyle: TextStyle(fontSize: 18, fontFamily: "Montserrat"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          textInputAction: TextInputAction.go,
                          onFieldSubmitted: (value) {
                            _emailFocus.requestFocus();
                          },
                          focusNode: _surNameFocus,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text("E-posta:", style: TextStyle(fontSize: 18, fontFamily: "Montserrat")),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "E-posta",
                  labelStyle: TextStyle(fontSize: 18, fontFamily: "Montserrat"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.go,
                onFieldSubmitted: (value) {
                  _passwordFocus.requestFocus();
                },
                focusNode: _emailFocus,
              ),
            ),
            SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text("Şifre:", style: TextStyle(fontSize: 18, fontFamily: "Montserrat")),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Şifre",
                  labelStyle: TextStyle(fontSize: 18, fontFamily: "Montserrat"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                textInputAction: TextInputAction.go,
                onFieldSubmitted: (value) {
                  _verifyPasswordFocus.requestFocus();
                },
                focusNode: _passwordFocus,
              ),
            ),
            SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text("Şifreyi Doğrula:", style: TextStyle(fontSize: 18, fontFamily: "Montserrat")),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: TextFormField(
                controller: _verifyPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Şifreyi Doğrula",
                  labelStyle: TextStyle(fontSize: 18, fontFamily: "Montserrat"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                focusNode: _verifyPasswordFocus,
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 30,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent[700]
                    ),
                      child: Text("Kayıt Ol", style: TextStyle(fontSize: 19, fontFamily: "Montserrat", color: Colors.white, fontWeight: FontWeight.w900)),
                      onPressed: () async {
                        if (_passwordController != _passwordController) {
                          ModernAlert(
                            context,
                            "Hata",
                            "Şifreler eşleşmiyor",
                            "Tamam",
                            () {}
                          );
                        }
                        else if (_nameController.text.isEmpty) {
                          ModernAlert(
                            context,
                            "Hata",
                            "Ad boş bırakılmaz",
                            "Tamam",
                            () {}
                          );
                        }
                        else if (_surNameController.text.isEmpty) {
                          ModernAlert(
                            context,
                            "Hata",
                            "Soyad boş bırakılmaz",
                            "Tamam",
                            () {}
                          );
                        }
                        else if (_emailController.text.isEmpty) {
                          ModernAlert(
                            context,
                            "Hata",
                            "E-posta boş bırakılmaz",
                            "Tamam",
                            () {}
                          );
                        }
                        else if (!EmailValidator.validate(_emailController.text)) {
                          ModernAlert(
                            context,
                            "Hata",
                            "E-posta adresi geçersiz.",
                            "Tamam",
                            () {}
                          );
                        }
                        else if (_passwordController.text.isEmpty) {
                          ModernAlert(
                            context,
                            "Hata",
                            "Şifre boş bırakılmaz",
                            "Tamam",
                            () {}
                          );
                        }
                        else if (_verifyPasswordController.text.isEmpty) {
                          ModernAlert(
                            context,
                            "Hata",
                            "Şifreyi doğrulama boş bırakılmaz",
                            "Tamam",
                            () {}
                          );
                        }
                        else if (_passwordController.text != _verifyPasswordController.text) {
                          ModernAlert(
                            context,
                            "Hata",
                            "Şifreler eşleşmiyor",
                            "Tamam",
                            () {}
                          );
                        }
                        else if (_passwordController.text.length < 6) {
                          ModernAlert(
                            context,
                            "Hata",
                            "Şifre en az 6 karakterden oluşmalıdır",
                            "Tamam",
                            () {}
                          );
                        }
                        else {
                          try {
                            await _auth.createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text
                            );
                            print("uid: " + _auth.currentUser!.uid);
                            FirebaseFirestore.instance.collection("users").doc(_auth.currentUser!.uid).set({
                              "uid": _auth.currentUser!.uid,
                              "name": _nameController.text,
                              "surname": _surNameController.text,
                              "email": _emailController.text,
                            });
                            Get.to(LoginPage());
                            ModernAlert(
                              context,
                              "Başarılı",
                              "Hesabınız oluşturuldu. Şimdi giriş yapabilirsiniz.",
                              "Tamam",
                              () {
                                
                              }
                            );
                          } on FirebaseAuthException catch(e) {
                            if (e.code == "email-already-in-use") {
                              ModernAlert(
                                context,
                                "Hata",
                                "E-posta adresi zaten kullanılıyor.",
                                "Tamam",
                                () {}
                              );
                            }
                            else if (e.code == "ERROR_WEAK_PASSWORD") {
                              ModernAlert(
                                context,
                                "Hata",
                                "Şifre yeterince güçlü değil.",
                                "Tamam",
                                () {}
                              );
                            }
                            else {
                              ModernAlert(
                                context,
                                "Hata",
                                "Bilinmeyen bir hata meydana geldi: ${e.code}",
                                "Tamam",
                                () {}
                              );
                            }
                          }
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}