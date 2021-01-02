import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'news_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Kayıt Ol'),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(143, 188, 143, 1),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "E-Mail"),
                validator: (String mail) {
                  if (mail.isEmpty || !mail.contains('@'))
                    return "Lütfen bir mail giriniz..";
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Şifre"),
                validator: (String password) {
                  if (password.isEmpty)
                    return "Lütfen şifrenizi giriniz..";
                  else if (password.length < 6) {
                    return "Şifre en az 6 karakter uzunluğunda olmalıdır.";
                  }
                  return null;
                },
                obscureText: true,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                alignment: Alignment.center,
                child: SignInButtonBuilder(
                  icon: Icons.person_add_alt_1,
                  backgroundColor: Color.fromRGBO(143, 188, 143, 1),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text);
                        final User user = userCredential.user;

                        if (user != null) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => RSSDemo(),
                            ),
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        switch (e.code) {
                          case 'weak-password':
                            final snackBar = SnackBar(
                              content: Text('Girilen şifre zayıf.'),
                            );
                            scaffoldKey.currentState.showSnackBar(snackBar);
                            break;
                          case 'emaıl-already-ın-use':
                            final snackBar = SnackBar(
                              content: Text('E-posta adresi zaten başka bir hesap tarafından kullanılıyor.'),
                            );
                            scaffoldKey.currentState.showSnackBar(snackBar);
                            break;
                        }
                      } catch (e) {
                        print('HATA! $e');
                      }
                    }
                  },
                  text: "Kayıt ol",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
