import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imgur/core/controller/paginations/page_index_pagination.dart';
import 'package:imgur/core/controller/paginations/temporary_hold_of_information.dart';
import 'package:imgur/screens/app/HomePage.dart';
import 'package:imgur/utils/modern_alert.dart';
import 'package:imgur/utils/modern_alert_two_buttons.dart';

class AccountSettingsPage extends StatefulWidget {
  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final TemporaryHoldOfInformation _infoHolder = Get.find();
  final PageIndexPaginationController _pageIndexController = Get.find();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    RxList info = _infoHolder.temporaryInformation;
    _nameController.text = info[0];
    _surnameController.text = info[1];
    _emailController.text = info[2];
  }

  void _showAlert(String title, String message) {
    ModernAlert(context, title, message, "Tamam", () {});
  }

  Future<void> _updateUserInformation() async {
    try {
      String userId = _infoHolder.temporaryInformation[3];
      await _firestore.collection("users").doc(userId).update({
        "name": _nameController.text,
        "surname": _surnameController.text,
        "email": _emailController.text,
      });

      if (_auth.currentUser!.email != _emailController.text) {
        await _auth.signInWithEmailAndPassword(
            email: _auth.currentUser!.email!, password: _passwordController.text);
        await _auth.currentUser!.updateEmail(_emailController.text);
      }

      _pageIndexController.pageIndex.value = 2;
      ModernAlert(context, "Başarılı", "Bilgileriniz güncellendi", "Tamam", () => Get.to(() => HomePage()));
    } catch (e) {
      _showAlert("Hata", "Güncelleme sırasında bir hata oluştu.");
    }
  }

  void _handleSaveButton() {
    if (_nameController.text.isEmpty || _surnameController.text.isEmpty || _emailController.text.isEmpty) {
      _showAlert("Hata", "Ad, Soyad ve E-posta alanları boş bırakılamaz.");
    } else {
      ModernAlertTwoButton(context, "Uyarı", "Bilgilerinizi güncellemek istediğinize emin misiniz?", "Evet", "Hayır", _updateUserInformation, () => Get.back());
    }
  }

  void _handleChangePassword() {
    _auth.sendPasswordResetEmail(email: _auth.currentUser!.email!);
    ModernAlert(context, "Başarılı", "Şifre değiştirme bağlantısı e-postanıza gönderildi.", "Tamam", () {});
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5.0, top: 20),
          child: Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 9),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hesap Ayarları"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            _buildTextField("Ad", _nameController),
            _buildTextField("Soyad", _surnameController),
            _buildTextField("E-posta", _emailController),
            const SizedBox(height: 15),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent[700],
                  padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: _handleChangePassword,
                child: const Text("Şifreyi Değiştir", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, fontFamily: "Montserrat")),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.edit),
        label: const Text('Kaydet', style: TextStyle(fontSize: 20)),
        onPressed: _handleSaveButton,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
