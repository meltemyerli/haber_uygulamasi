import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share/share.dart';

class NewsDetail extends StatelessWidget {
  String _link, _title;
  NewsDetail(this._link, this._title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Share.share(
                _title + ' ' + _link,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.share),
            ),
          ),
        ],
      ),
      body: WebView(
        initialUrl: _link,
      ),
    );
  }
}
