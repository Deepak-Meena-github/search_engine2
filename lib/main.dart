// ignore_for_file: non_constant_identifier_names, unused_label

import 'package:flutter/material.dart';
//import 'scr.dart';
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

// class firrstpage extends StatelessWidget {
//   firrstpage({super.key});
//   final _categoryNameController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Material(
//         color: Colors.white,
//         child: Center(
//             child: ListView(
//           children: <Widget>[
//             const Padding(padding: EdgeInsets.all(30.0)),
//             // new Image.asset('images/photohobay.png',
//             // width: 200.0,
//             // height: 200.0
//             // ,)
//             ListTile(
//               title: TextFormField(
//                 controller: _categoryNameController,
//                 decoration: InputDecoration(
//                     labelText: "enter a categary",
//                     hintText: 'eg, dogs, cats...',
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25.0)),
//                     contentPadding:
//                         const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0)),
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.all(4.0),
//             ),
//             ListTile(
//               title: Material(
//                   color: Colors.blue,
//                   elevation: 5.0,
//                   borderRadius: BorderRadius.circular(25.0),
//                   child: MaterialButton(
//                     height: 10,
//                     onPressed: () {},
//                     child: const Text('search',
//                         style: TextStyle(
//                             fontSize: 22.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white)),
//                   )),
//             )
//           ],
//         )),
//       ),
//     );
//   }
// }

// class SecondPage extends StatefulWidget {
//   const SecondPage({super.key});

//   @override
//   State<SecondPage> createState() => _SecondPageState();
// }

// class _SecondPageState extends State<SecondPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.blue,
//           title: const Text(
//             'search',
//             style: TextStyle(color: Colors.white),
//           ),
//           centerTitle: true,
//         ),
//         body: FutureBuilder(
//             future: GetPics(),
//             builder: (context, snapshot) {
//               Map? data = snapshot.data;
//               if (snapshot.hasError) {
//                 print(snapshot.error);
//                 return const Text('faild to get response form the server');
//               } else if (snapshot.hasData) {
//                 return Center(
//                   child: ListView.builder(
//                     itemCount: data!.length,
//                     itemBuilder: (context, index) {
//                       childern:
//                       <Widget>[
//                         const Padding(padding: EdgeInsets.all(5.0)),
//                         InkWell(
//                           onTap: () {},
//                           child: Image.network(
//                               '${data['hits'][index]['largeImageUrl']}'),
//                         )
//                       ];
//                     },
//                   ),
//                 );
//               }
//               return const Center(child: CircularProgressIndicator());
//             }));
//   }
// }
Map<String, dynamic>? map;
Future<Map> GetPics(value) async {
  const apiKey = '36684516-4d8c0a326c01fc11ecba49112';
  String url =
      'https://pixabay.com/api/?key=$apiKey&q=$value&image_type=photo&pretty=true';

  http.Response response = await http.get(Uri.parse(url));
  print(json.decode(response.body));
  map = json.decode(response.body);
  return json.decode(response.body);
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView.builder(
              padding: EdgeInsets.only(top: 100),
              itemCount: map?["hits"]?.length ?? 0,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.network(
                      map!["hits"][index]["userImageURL"],
                      errorBuilder: (context, error, stackTrace) {
                        return const CircleAvatar(
                          child: Icon(Icons.not_accessible),
                        );
                      },
                    ),
                    title: Text(map!["hits"][index]["user"]),
                  ),
                );
              }),
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
              ))
        ],
      ),
    );
  }
}