import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_app/news_page.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Giriş Yap"),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(143, 188, 143, 1),
      ),
      body: Container(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            Column(
              children: [
                Form(
                  key: _formKey,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              "Email ve Şifre ile Giriş Yap",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            alignment: Alignment.center,
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration:
                                const InputDecoration(labelText: "E-Mail"),
                            validator: (String mail) {
                              if (mail.isEmpty || !mail.contains('@'))
                                return "Lütfen bir mail giriniz..";
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration:
                                const InputDecoration(labelText: "Şifre"),
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
                            padding: const EdgeInsets.only(top: 16.0),
                            alignment: Alignment.center,
                            child: SignInButton(Buttons.Email,
                                text: "Email ile giriş yap",
                                onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                try {
                                  UserCredential userCredential =
                                      await FirebaseAuth
                                          .instance
                                          .signInWithEmailAndPassword(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text);

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
                                    case 'user-not-found':
                                      final snackBar = SnackBar(
                                        content: Text(
                                            "Bu e-posta için kullanıcı bulunamadı."),
                                      );
                                      scaffoldKey.currentState
                                          .showSnackBar(snackBar);
                                      break;
                                    case 'wrong-password':
                                      final snackBar = SnackBar(
                                        content: Text("Yanlış şifre girildi"),
                                      );
                                      scaffoldKey.currentState
                                          .showSnackBar(snackBar);
                                      break;
                                  }
                                } catch (e) {
                                  print('HATA! $e');
                                }
                              }
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Color.fromRGBO(238, 238, 224, 0.7),
                  child: Column(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Diğer Giriş Yöntemleri',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        alignment: Alignment.center,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        child: SignInButton(
                          Buttons.Google,
                          text: "Google ile giriş yap",
                          onPressed: () async {
                            try {
                              final GoogleSignInAccount googleUser =
                                  await GoogleSignIn().signIn();
                              final GoogleSignInAuthentication googleAuth =
                                  await googleUser.authentication;
                              final GoogleAuthCredential credential =
                                  GoogleAuthProvider.credential(
                                      accessToken: googleAuth.accessToken,
                                      idToken: googleAuth.idToken);

                              final UserCredential userCredential =
                                  await FirebaseAuth.instance
                                      .signInWithCredential(credential);
                              final User user = userCredential.user;

                              if (user != null) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => RSSDemo(),
                                  ),
                                );
                              }
                            } on FirebaseAuthException catch (e) {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.code),
                                ),
                              );
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
