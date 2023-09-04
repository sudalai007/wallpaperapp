import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var urlData;
  void getApiData() async {
    var url = Uri.parse(
        'https://api.unsplash.com/photos/?per_page=30&client_id=8T03DP-4WynsS06tMrXKhkEPjznEc2vWd7yMazUEwag');
    final res = await http.get(url);
    setState(() {
      urlData = jsonDecode(res.body);
      print(urlData);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApiData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wallpaper App"),
      ),
      body: Center(
          child: urlData == null
              ? CircularProgressIndicator()
              : GridView.builder(
                  itemCount: 30,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2),
                  itemBuilder: (context, i) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FullImageView(
                                      url: urlData[i]['urls']['full'],
                                    )));
                      },
                      child: Hero(
                        tag: 'full',
                        child: Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        urlData[i]['urls']['full']))),
                          ),
                        ),
                      ),
                    );
                  })),
    );
  }
}

class FullImageView extends StatelessWidget {
  var url;
  FullImageView({this.url});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'full',
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
              image:
                  DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
