import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:imgur/screens/LoginAndRegister/RegisterPage.dart';
import 'package:imgur/utils/modern_alert.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FocusNode passwordFocus = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    passwordFocus.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ModernAlert(
          context, "Hata", "E-posta ve parola boş bırakılamaz.", "Tamam");
      return;
    }
    if (!EmailValidator.validate(emailController.text)) {
      ModernAlert(
          context, "Hata", "Geçerli bir e-posta adresi giriniz.", "Tamam");
      emailController.clear();
      return;
    }
    if (passwordController.text.length < 6) {
      ModernAlert(
          context, "Hata", "Parola en az 6 karakter olmalıdır.", "Tamam");
      passwordController.clear();
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
    }
  }

  void _handleFirebaseAuthError(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case "user-not-found":
        message = "Böyle bir kullanıcı bulunamadı.";
        break;
      case "wrong-password":
        message = "Şifre yanlış.";
        break;
      case "user-disabled":
        message = "Kullanıcı hesabı devre dışı bırakılmış.";
        break;
      case "too-many-requests":
        message =
            "Çok fazla giriş denemesi yaptınız. Lütfen daha sonra tekrar deneyin.";
        break;
      default:
        message = "Bilinmeyen bir hata meydana geldi: ${e.message}";
        break;
    }
    ModernAlert(context, "Hata", message, "Tamam");
    emailController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/Logo.png",
                height: 200, width: 250, fit: BoxFit.cover),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text("Giriş Yap",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat")),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("E-posta ve şifrenizi giriniz.",
                  style: TextStyle(fontSize: 18, fontFamily: "Montserrat")),
            ),
            const SizedBox(height: 16),
            _buildTextField(emailController, "E-posta",
                TextInputType.emailAddress, TextInputAction.next, null),
            const SizedBox(height: 15),
            _buildTextField(passwordController, "Parola", TextInputType.text,
                TextInputAction.done, passwordFocus,
                obscureText: true),
            const SizedBox(height: 15),
            _buildLoginButton(),
            _buildForgotPassword(),
            _buildRegisterButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      TextInputType keyboardType,
      TextInputAction textInputAction,
      FocusNode? focusNode,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
        ),
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        focusNode: focusNode,
        obscureText: obscureText,
      ),
    );
  }

  Widget _buildLoginButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent[700],
          minimumSize: const Size.fromHeight(50),
        ),
        onPressed: _login,
        child: const Text("Giriş Yap",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Center(
      child: TextButton(
        onPressed: () {
          // Implement forgot password functionality
        },
        child: const Text("Şifremi Unuttum",
            style: TextStyle(fontSize: 16, color: Color(0xFF2962FF))),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextButton(
          onPressed: () => Get.to(() => RegisterPage()),
          child: const Text("Hesap Oluştur",
              style: TextStyle(fontSize: 18, color: Color(0xFF2962FF))),
        ),
      ),
    );
  }
}
