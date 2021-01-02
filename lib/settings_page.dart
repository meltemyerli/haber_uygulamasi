import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_app/developer_page.dart';
import 'package:news_app/home_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var width;
  var height;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Ayarlar'),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(143, 188, 143, 1),
      ),
      backgroundColor: Color.fromRGBO(238, 238, 224, 0.9),
      body: Column(
        children: [
          Container(
            width: width,
            height: height * .08,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: RaisedButton.icon(
                onPressed: () {
                  showLicensePage(
                    context: context,applicationName: "Breeze Haber",applicationVersion: "v1.0",
                  );
                },
                icon: Icon(Icons.grading),
                label: Text('Lisanslar'),
                color: Colors.white,
              ),
            ),
          ),
          Container(
            width: width,
            height: height * .08,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: RaisedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => DeveloperPage()));
                },
                icon: Icon(Icons.developer_mode),
                label: Text('Geliştirici'),
                color: Colors.white,
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(height: height*.05,width: width*.7,
              child: RaisedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (await GoogleSignIn().isSignedIn()) {
                    await GoogleSignIn().disconnect();
                    await GoogleSignIn().signOut();
                  }
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                icon: Icon(Icons.exit_to_app),
                label: Text('ÇIKIŞ YAP',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
void showLicensePage({
  @required BuildContext context,
  String applicationName,
  String applicationVersion,
  Widget applicationIcon,
  String applicationLegalese,
  bool useRootNavigator = false,
}) {
  assert(context != null);
  assert(useRootNavigator != null);
  Navigator.of(context, rootNavigator: useRootNavigator)
      .push(MaterialPageRoute<void>(
    builder: (BuildContext context) => LicensePage(
      applicationName: applicationName,
      applicationVersion: applicationVersion,
      applicationIcon: applicationIcon,
      applicationLegalese: applicationLegalese,
    ),
  ));
}
