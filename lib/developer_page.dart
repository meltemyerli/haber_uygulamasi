import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperPage extends StatefulWidget {
  @override
  _DeveloperPageState createState() => _DeveloperPageState();
}

class _DeveloperPageState extends State<DeveloperPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geliştirici'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Image.asset('assets/images/meltem_yerli.png',height: 400,),
            ),
            SizedBox(height: 50,),
            Container(
              alignment: Alignment.center,
              child: SignInButton(Buttons.GitHub, text: "meltemyerli",
                  onPressed: () async {
                _launchURL();
              }),
            ),
          ],
        ),
      ),
    );
  }
}
_launchURL() async {
  const url = 'https://github.com/meltemyerli';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
