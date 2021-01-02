import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:news_app/news_page.dart';
import 'package:news_app/register_page.dart';
import 'package:news_app/signin_page.dart';

class HomeScreen extends StatelessWidget {
  var width;
  var height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(238, 238, 224, 0.7),
        elevation: 0.1,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Color.fromRGBO(238, 238, 224, 0.9),
      body: Column(
        children: [
          Container(
            width: width * .8,
            height: height * .5,
            child: Image.asset(
              'assets/images/haber2.png',
            ),
          ),
          Container(
            child: SignInButtonBuilder(
              height: height * 0.05,
              width: width * 0.6,
              icon: Icons.person_add_alt_1,
              backgroundColor: Color.fromRGBO(143, 188, 143, 1),
              text: "Kayıt Ol",
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => RegisterPage())),
            ),
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
          ),
          Container(
            child: SignInButtonBuilder(
              height: height * 0.05,
              width: width * 0.6,
              icon: Icons.login,
              backgroundColor: Color.fromRGBO(143, 188, 143, 1),
              text: "Giriş Yap",
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      FirebaseAuth.instance.currentUser == null
                          ? SignInPage()
                          : RSSDemo(),
                ),
              ),
            ),
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
          )
        ],
      ),
    );
  }
}
