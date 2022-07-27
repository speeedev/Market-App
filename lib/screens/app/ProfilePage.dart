import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market_cebimde/paginations/temporary_hold_of_information.dart';
import 'package:market_cebimde/screens/app/AccountSettingsPage.dart';
import 'package:market_cebimde/screens/app/HistoryOrdersPage.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List <SettingsMenuManager> settingMenu = [SettingsMenuManager(name: "Hesap Ayarları"), SettingsMenuManager(name: "Geçmiş Siparişler"), SettingsMenuManager(name: "Çıkış")];
  List <SettingsMenuManager> settingMenu2 = [SettingsMenuManager(name: "Hakkımızda"), SettingsMenuManager(name: "Gizlilik Sözleşmesi")];
  TemporaryHoldOfInformation _temporaryHoldOfInformation = Get.put(TemporaryHoldOfInformation());
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? name;
  String? surname;
  String? email;
  String? uID;
  @override
  void initState() {
    super.initState();
    _firestore
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .get()
      .then((value) {
        setState(() {
          name = value.data()!["name"];
          surname = value.data()!["surname"];
        });
      });
    print("uid" + FirebaseAuth.instance.currentUser!.uid.toString());
    setState(() {
      email = _auth.currentUser!.email;
      uID = _auth.currentUser!.uid;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[700],
        title: const Text("Hesap", style: const TextStyle(color: Colors.white),),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Text("Merhaba, ${name}", style: const TextStyle(fontSize: 30, fontFamily: "Montserrat")),
            ),
            SizedBox(height: 10),
            Center(
              child: Text("${email}", style: const TextStyle(fontSize: 17, fontFamily: "Montserrat")),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ListView.builder(
              itemCount: settingMenu.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(), // here
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text(settingMenu[index].name, style: TextStyle(fontSize: 18, fontFamily: "Montserrat"),),
                  onTap: () {
                    if (settingMenu[index].name == "Hesap Ayarları") {
                      _temporaryHoldOfInformation.temporaryInformation.value = [
                        name,
                        surname,
                        email,
                        uID
                      ];
                      Get.to(AccountSettingsPage());
                    }
                    else if (settingMenu[index].name == "Geçmiş Siparişler") {
                      Get.to(HistoryOrdersPage());
                    }
                    else if (settingMenu[index].name == "Çıkış") {
                      _auth.signOut();
                    }
                  },
                );
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            ListView.builder(
              itemCount: settingMenu2.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(), // here
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text(settingMenu2[index].name, style: TextStyle(fontSize: 18, fontFamily: "Montserrat"),),
                  onTap: () {
                    if (settingMenu2[index].name == "Hakkımızda") {
                    //  Get.to(AboutPage());
                    }
                    else if (settingMenu2[index].name == "Gizlilik Sözleşmesi") {
                    //  Get.to(PrivacyPolicyPage());
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsMenuManager {
  final String name;
  SettingsMenuManager({required this.name});
  }
