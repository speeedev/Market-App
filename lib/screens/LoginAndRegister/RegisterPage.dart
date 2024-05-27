import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:imgur/screens/LoginAndRegister/LoginPage.dart';
import 'package:imgur/utils/modern_alert.dart';

class RegisterPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _verifyPasswordController =
      TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _surNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _verifyPasswordFocus = FocusNode();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/Logo.png",
                height: 200, width: 250, fit: BoxFit.cover),
            _buildHeaderText('Kayıt Ol'),
            _buildTextFormField(
                _nameController, 'Ad', _nameFocus, _surNameFocus, context),
            _buildTextFormField(_surNameController, 'Soyad', _surNameFocus,
                _emailFocus, context),
            _buildTextFormField(_emailController, 'E-posta', _emailFocus,
                _passwordFocus, context,
                keyboardType: TextInputType.emailAddress),
            _buildPasswordFormField(_passwordController, 'Şifre',
                _passwordFocus, _verifyPasswordFocus),
            _buildPasswordFormField(_verifyPasswordController,
                'Şifreyi Doğrula', _verifyPasswordFocus, null),
            _buildRegisterButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderText(String text) => Padding(
        padding: const EdgeInsets.all(10),
        child: Text(text,
            style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: "Montserrat")),
      );

  Widget _buildTextFormField(TextEditingController controller, String label,
          FocusNode focusNode, FocusNode? nextFocusNode, BuildContext context,
          {TextInputType keyboardType = TextInputType.text}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(fontSize: 18, fontFamily: "Montserrat"),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
          keyboardType: keyboardType,
          textInputAction: nextFocusNode != null
              ? TextInputAction.next
              : TextInputAction.done,
          onFieldSubmitted: (_) => nextFocusNode?.requestFocus(),
          focusNode: focusNode,
        ),
      );

  Widget _buildPasswordFormField(TextEditingController controller, String label,
          FocusNode focusNode, FocusNode? nextFocusNode) =>
      _buildTextFormField(controller, label, focusNode, nextFocusNode,
          keyboardType: TextInputType.visiblePassword);

  Widget _buildRegisterButton(BuildContext context) => Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 30,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent[700]),
            child: const Text("Kayıt Ol",
                style: TextStyle(
                    fontSize: 19,
                    fontFamily: "Montserrat",
                    color: Colors.white,
                    fontWeight: FontWeight.w900)),
            onPressed: () => _register(context),
          ),
        ),
      );

  Future<void> _register(BuildContext context) async {
    if (_passwordController.text != _verifyPasswordController.text) {
      _showAlert(context, "Hata", "Şifreler eşleşmiyor", "Tamam");
      return;
    }
    if (!EmailValidator.validate(_emailController.text)) {
      _showAlert(context, "Hata", "E-posta adresi geçersiz.", "Tamam");
      return;
    }
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        "uid": userCredential.user!.uid,
        "name": _nameController.text,
        "surname": _surNameController.text,
        "email": _emailController.text,
      });
      Get.to(() => LoginPage());
      _showAlert(context, "Başarılı",
          "Hesabınız oluşturuldu. Şimdi giriş yapabilirsiniz.", "Tamam");
    } catch (e) {
      _handleFirebaseAuthError(e, context);
    }
  }

  void _showAlert(
      BuildContext context, String title, String message, String buttonText) {
    ModernAlert(context, title, message, buttonText, () {});
  }

  void _handleFirebaseAuthError(FirebaseAuthException e, BuildContext context) {
    String message = "Bilinmeyen bir hata meydana geldi: ${e.code}";
    if (e.code == "email-already-in-use") {
      message = "E-posta adresi zaten kullanılıyor.";
    } else if (e.code == "weak-password") {
      message = "Şifre yeterince güçlü değil.";
    }
    _showAlert(context, "Hata", message, "Tamam");
  }
}
