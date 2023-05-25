import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SearchPage(),
  ));
}

Map<String, dynamic>? map;

Future<Map> GetPics(String value) async {
  const apiKey = '36684516-4d8c0a326c01fc11ecba49112';
  String url =
      'https://pixabay.com/api/?key=$apiKey&q=$value&image_type=photo&pretty=true';

  http.Response response = await http.get(Uri.parse(url));
  print(json.decode(response.body));
  map = json.decode(response.body);
  return json.decode(response.body);
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GridView.builder(
            padding: EdgeInsets.only(top: 100),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: map?["hits"]?.length ?? 0,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImage(
                        imageUrl: map!["hits"][index]["largeImageURL"],
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: map!["hits"][index]["largeImageURL"],
                  child: Image.network(
                    map!["hits"][index]["webformatURL"],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 30,
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: 70,
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(border: OutlineInputBorder()),
                onChanged: (value) async {
                  await GetPics(value);
                  setState(() {});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          color: Colors.black,
          child: Center(
            child: Hero(
              tag: imageUrl,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
