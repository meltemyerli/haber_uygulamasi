import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_app/settings_page.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

import 'news_detail_page.dart';

class RSSDemo extends StatefulWidget {
  RSSDemo() : super();
  final String title = 'RSS Feed Demo';
  @override
  _RSSDemoState createState() => _RSSDemoState();
}

class _RSSDemoState extends State<RSSDemo> {
  static const String FEED_URL = 'https://www.haberturk.com/rss';

  List<RssItem> searchList;

  RssFeed _feed;
  String _title;
  static const String loadingFeedMsg = 'Veriler Yükleniyor..';
  static const String feedLoadErrorMsg = 'Error loading feed..';
  static const String placeholderImg = 'assets/images/no_image.jpg';
  GlobalKey<RefreshIndicatorState> _refreshKey;
  final TextEditingController _searchController = TextEditingController();

  updateTitle(title) {
    setState(() {
      _title = title;
    });
  }

  updateFeed(feed) {
    setState(() {
      _feed = feed;
    });
  }

  load() async {
    updateTitle(loadingFeedMsg);
    loadFeed().then((result) {
      if (null == result || result.toString().isEmpty) {
        updateTitle(feedLoadErrorMsg);
        return;
      }
      updateFeed(result);
      updateTitle(_feed.title);
    });
  }

  Future<RssFeed> loadFeed() async {
    try {
      final client = http.Client();
      final response = await client.get(FEED_URL);
      final result = RssFeed.parse(utf8.decode(response.bodyBytes));
      return result;
    } catch (e) {}
    return null;
  }

  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    updateTitle(widget.title);
    load();
  }

  title(title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  subtitle(subTitle) {
    return Text(
      subTitle,
      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w100),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  thumbnail(imageUrl) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: CachedNetworkImage(
        placeholder: (context, url) => Image.asset(placeholderImg),
        imageUrl: imageUrl,
        height: 50,
        width: 70,
        alignment: Alignment.center,
        fit: BoxFit.fill,
      ),
    );
  }

  rightIcon() {
    return Icon(
      Icons.keyboard_arrow_right,
      color: Colors.grey,
      size: 30.0,
    );
  }

  list() {
    return _searchController.text.isNotEmpty
        ? ListView.builder(
            itemCount: searchList
                .length, // burda rssde oolan haberlerin sayısı kadar liste oluşturuyosun
            itemBuilder: (BuildContext context, int index) {
              final item = searchList[index];
              return ListTile(
                title: title(item.title),
                subtitle: subtitle(item.pubDate.toString()),
                leading: thumbnail(item.enclosure.url),
                trailing: rightIcon(),
                contentPadding: EdgeInsets.all(5.0),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsDetail(item.link, item.title),
                    ),
                  );
                },
              );
            },
          )
        : ListView.builder(
            itemCount: _feed.items
                .length,
            itemBuilder: (BuildContext context, int index) {
              final item = _feed.items[
                  index];
              return ListTile(
                title: title(item.title),
                subtitle: subtitle(item.pubDate.toString()),
                leading: thumbnail(item.enclosure.url),
                trailing: rightIcon(),
                contentPadding: EdgeInsets.all(5.0),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsDetail(item.link, item.title),
                    ),
                  );
                },
              );
            },
          );
  }

  isFeedEmpty() {
    return null == _feed || null == _feed.items;
  }

  body() {
    return isFeedEmpty()
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            key: _refreshKey,
            child: list(),
            onRefresh: () => load(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          cursorColor: Colors.white,
          decoration: InputDecoration(
              hintText: "Haber arayabilirsiniz..",
              border: InputBorder.none,
              suffixIcon: SizedBox(
                width: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: IconButton(
                        icon: Icon(Icons.search),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            searchList = _feed.items
                                .where((element) => element.title
                                    .toLowerCase()
                                    .contains(_searchController.text))
                                .toList();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            searchList.clear();
                          });
                        },
                      ),
                    )
                  ],
                ),
              )),
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        backgroundColor: Color.fromRGBO(143, 188, 143, 1),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: body(),
    );
  }
}
