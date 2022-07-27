import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:market_cebimde/functions/modern_alert.dart';
import 'package:market_cebimde/functions/modern_alert_two_buttons.dart';
import 'package:market_cebimde/main.dart';
import 'package:market_cebimde/paginations/page_index_pagination.dart';
import 'package:market_cebimde/paginations/temporary_hold_of_information.dart';
import 'package:market_cebimde/screens/app/Home.dart';
import 'package:market_cebimde/screens/app/HomePage.dart';
import 'package:restart_app/restart_app.dart';

class AccountSettingsPage extends StatefulWidget {
  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}
TemporaryHoldOfInformation _temporaryHoldOfInformation = Get.put(TemporaryHoldOfInformation());
final inComingList = _temporaryHoldOfInformation.temporaryInformation;
String uID = _temporaryHoldOfInformation.temporaryInformation[3];
class _AccountSettingsPageState extends State<AccountSettingsPage> {
  TextEditingController _nameController = TextEditingController(text: inComingList[0]);
  TextEditingController _surnameController = TextEditingController(text: inComingList[1]);
  TextEditingController _emailController = TextEditingController(text: inComingList[2]);
  TextEditingController _uIDController = TextEditingController(text: inComingList[3]);
  TextEditingController _verifyPasswordController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  PageIndexPaginationController _pageIndexPaginationController = Get.put(PageIndexPaginationController());
  TemporaryHoldOfInformation _temporaryHoldOfInformation = Get.put(TemporaryHoldOfInformation());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hesap Ayarları"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent[700],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text("Ad", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 9),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text("Soyad", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 9),
              TextFormField(
                controller: _surnameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text("E-posta", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 9),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent[700],
                    padding: EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text("Şifreyi Değiştir", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, fontFamily: "Montserrat")),
                  onPressed: () {
                    _auth.sendPasswordResetEmail(email: _auth.currentUser!.email.toString());
                    ModernAlert(
                      context,
                      "Başarılı",
                      "Şifre değiştirme bağlantısı e-postası adresinize gönderildi.",
                      "Tamam",
                      () {
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.edit),
        label: const Text('Kaydet', style: TextStyle(fontSize: 20)),
        onPressed: () {
          if (_nameController.text.isEmpty) {
            ModernAlert(
              context,
              "Hata",
              "Ad boş bırakılamaz.",
              "Tamam",
              () {}
            );
          }
          else if (_surnameController.text.isEmpty) {
            ModernAlert(
              context,
              "Hata",
              "Soyad boş bırakılamaz.",
              "Tamam",
              () {}
            );
          }
          else if (_emailController.text.isEmpty) {
            ModernAlert(
              context,
              "Hata",
              "E-posta boş bırakılamaz.",
              "Tamam",
              () {}
            );
          }
          else {
            ModernAlertTwoButton(
              context,
              "Uyarı",
              "Bilgilerinizi güncellemek istediğinize emin misiniz?",
              "Evet",
              "Hayır",
              () {
                _firestore.collection("users").doc(uID).update({
                  "name": _nameController.text,
                  "surname": _surnameController.text,
                  "email": _emailController.text,
                });
                if (auth.currentUser!.email != _emailController) {
                  AlertDialog _passwordLoginAlert = AlertDialog(
                    title: Text("Şifrenizi Doğrulayın", style: TextStyle(fontSize: 20)),
                    content: TextFormField(
                      controller: _verifyPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: "Şifreniz",
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: Text("iptal", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "Montserrat", color: Colors.red)),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      TextButton(
                        child: Text("Onayla", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "Montserrat", color: Colors.blue)),
                        onPressed: () {
                          _auth.signInWithEmailAndPassword(
                            email: auth.currentUser!.email.toString(),
                            password: _verifyPasswordController.text,
                          ).then((value) {
                            auth.currentUser!.updateEmail(_emailController.text).then((value) {
                              Get.back();
                              Get.back();
                              Get.back();
                              _pageIndexPaginationController.pageIndex.value = 2;
                              ModernAlert(
                                context,
                                "Başarılı",
                                "Bilgileriniz, uygulamayı yeniden başlattıktan sonra güncellenecektir.",
                                "Tamam",
                                () {
                                  Get.to(HomePage());
                                }
                              );
                            });
                          }).catchError((e) {
                            ModernAlert(
                              context,
                              "Hata",
                              "Şifrenizi doğru girmediğiniz için güncelleme başarısız oldu.",
                              "Tamam",
                              () {
                                Get.to(HomePage());
                              }
                            );
                          });
                        },
                      ),
                    ],
                  );
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => _passwordLoginAlert,
                  );
                }
              },
              () {
                Get.back();
              },
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
}