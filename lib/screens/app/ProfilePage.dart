import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imgur/core/controller/paginations/temporary_hold_of_information.dart';
import 'package:imgur/screens/app/AccountSettingsPage.dart';
import 'package:imgur/screens/app/HistoryOrdersPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<SettingsMenuManager> settingMenu = [
    SettingsMenuManager(name: "Hesap Ayarları"),
    SettingsMenuManager(name: "Geçmiş Siparişler"),
    SettingsMenuManager(name: "Çıkış"),
  ];
  final List<SettingsMenuManager> settingMenu2 = [
    SettingsMenuManager(name: "Hakkımızda"),
    SettingsMenuManager(name: "Gizlilik Sözleşmesi"),
  ];

  final TemporaryHoldOfInformation _temporaryHoldOfInformation = Get.put(TemporaryHoldOfInformation());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? name;
  String? surname;
  String? email;
  String? uID;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userDoc = await _firestore.collection("users").doc(_auth.currentUser?.uid).get();
    if (userDoc.exists) {
      setState(() {
        name = userDoc.data()?["name"];
        surname = userDoc.data()?["surname"];
      });
    }

    setState(() {
      email = _auth.currentUser?.email;
      uID = _auth.currentUser?.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[700],
        title: const Text("Hesap", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                "Merhaba, ${name ?? ''}",
                style: const TextStyle(fontSize: 30, fontFamily: "Montserrat"),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "${email ?? ''}",
                style: const TextStyle(fontSize: 17, fontFamily: "Montserrat"),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            _buildSettingsList(settingMenu, context),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            _buildSettingsList(settingMenu2, context),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsList(List<SettingsMenuManager> settings, BuildContext context) {
    return ListView.builder(
      itemCount: settings.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.person),
          title: Text(
            settings[index].name,
            style: const TextStyle(fontSize: 18, fontFamily: "Montserrat"),
          ),
          onTap: () => _handleSettingsTap(settings[index].name),
        );
      },
    );
  }

  void _handleSettingsTap(String settingName) {
    switch (settingName) {
      case "Hesap Ayarları":
        _temporaryHoldOfInformation.temporaryInformation.value = [name, surname, email, uID];
        Get.to(() => AccountSettingsPage());
        break;
      case "Geçmiş Siparişler":
        Get.to(() => HistoryOrdersPage());
        break;
      case "Çıkış":
        _auth.signOut();
        break;
      case "Hakkımızda":
        // Get.to(AboutPage());
        break;
      case "Gizlilik Sözleşmesi":
        // Get.to(PrivacyPolicyPage());
        break;
    }
  }
}

class SettingsMenuManager {
  final String name;

  SettingsMenuManager({required this.name});
}
