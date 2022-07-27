import 'package:email_validator/email_validator.dart';
import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:market_cebimde/functions/modern_alert.dart';
import "package:market_cebimde/main.dart";
import "package:market_cebimde/screens/LoginAndRegister/RegisterPage.dart";
import "package:market_cebimde/screens/LoginAndRegister/loginPage.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market_cebimde/screens/app/Home.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late FocusNode passwordFocus;

  @override
  void initState() {
    super.initState();
    passwordFocus = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    passwordFocus.dispose();
  }
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset("assets/Logo.png", height: 200, width: 250, fit: BoxFit.cover),
        const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text("Giriş Yap", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: "Montserrat")),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 10, top: 10),
          child: Text("E-posta ve şifrenizi giriniz.", style: TextStyle(fontSize: 18, fontFamily: "Montserrat")),
        ),
        SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "E-posta",
                labelStyle: TextStyle(fontSize: 18, fontFamily: "Montserrat"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.go,
              onFieldSubmitted: (value) {
                passwordFocus.requestFocus();
              },
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Parola",
                labelStyle: TextStyle(fontSize: 18, fontFamily: "Montserrat"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              obscureText: true,
              focusNode: passwordFocus,
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 30,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent[700]
                ),
                child: Text("Giriş Yap", style: TextStyle(fontSize: 19, fontFamily: "Montserrat", color: Colors.white, fontWeight: FontWeight.w900)),
                onPressed: () async {
                  try {
                    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                      ModernAlert(
                        context,
                        "Hata",
                        "E-posta ve parola boş bırakılamaz.",
                        "Tamam",
                        () {
                          Get.back();
                        },
                      );
                    }
                    else if (_passwordController.text.length < 6) {
                      ModernAlert(
                        context,
                        "Hata",
                        "Parola en az 6 karakter olmalıdır.",
                        "Tamam",
                        () {
                          _passwordController.clear();
                          Get.back();
                        },
                      );
                    } else if (!EmailValidator.validate(_emailController.text)) {
                      ModernAlert(
                        context,
                        "Hata",
                        "Geçerli bir e-posta adresi giriniz.",
                        "Tamam",
                        () {
                          _emailController.clear();
                          Get.back();
                        },
                      );
                    }
                    else {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    print(e.code);
                    print(e.message);
                    if (e.code == "user-not-found") {
                      ModernAlert(
                        context,
                        "Hata",
                        "Böyle bir kullanıcı bulunamadı.",
                        "Tamam",
                        () {
                          _emailController.clear();
                          _passwordController.clear();
                          Get.back();
                        },
                      );
                      return;
                    } else if (e.code == "wrong-password") {
                      ModernAlert(
                        context,
                        "Hata",
                        "Şifre yanlış.",
                        "Tamam",
                        () {
                          _passwordController.clear();
                          Get.back();
                        },
                      );
                      return;
                    } else if (e.code == "user-disabled") {
                      ModernAlert(
                        context,
                        "Hata",
                        "Kullanıcı hesabı devre dışı bırakılmış..",
                        "Tamam",
                        () {
                          _emailController.clear();
                          _passwordController.clear();
                          Get.back();
                        },
                      );
                      return;
                    } else if (e.code == "too-many-requests") {
                      ModernAlert(
                        context,
                        "Hata",
                        "Çok fazla giriş denemesi yaptınız. Lütfen daha sonra tekrar deneyin.",
                        "Tamam",
                        () {
                          _emailController.clear();
                          _passwordController.clear();
                          Get.back();
                        }
                      );
                      return;
                    } else {
                      ModernAlert(
                        context,
                        "Hata",
                        "Bilinmeyen bir hata meydana geldi: ${e.code} + ${e.message}",
                        "Tamam",
                        () {
                          _emailController.clear();
                          _passwordController.clear();
                          Get.back();
                        },
                      );
                    }
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Şifrenizi mi unuttunuz? ",
                    style: TextStyle(fontSize: 16, fontFamily: "Montserrat", color: Colors.black),
                  ),
                  TextSpan(
                    text: "Şifremi Unuttum",
                    style: TextStyle(fontSize: 16, fontFamily: "Montserrat", color: Colors.blueAccent[700]),
                  ),
                ]
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  child: Text("Hesap Oluştur", style: TextStyle(fontSize: 18, fontFamily: "Montserrat", color: Colors.blueAccent[700])),
                  onTap: () {
                    Get.to(RegisterPage());
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}