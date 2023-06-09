import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



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

class SearchPage1 extends StatefulWidget {
  const SearchPage1({Key? key});

  @override
  State<SearchPage1> createState() => _SearchPage1State();
}

class _SearchPage1State extends State<SearchPage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Gallery'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
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
                        images: map!["hits"],
                        initialIndex: index,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: map!["hits"][index]["largeImageURL"],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      map!["hits"][index]["webformatURL"],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 30,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  hintText: 'Search for images...',
                  contentPadding: const EdgeInsets.all(16.0),
                  suffixIcon: Icon(Icons.search),
                ),
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

class FullScreenImage extends StatefulWidget {
  final List<dynamic> images;
  final int initialIndex;

  const FullScreenImage({
    required this.images,
    required this.initialIndex,
  });

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _navigateBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dx > 0) {
            // Swiped Right
            if (_currentIndex > 0) {
              setState(() {
                _currentIndex--;
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              });
            }
          } else if (details.velocity.pixelsPerSecond.dx < 0) {
            // Swiped Left
            if (_currentIndex < widget.images.length - 1) {
              setState(() {
                _currentIndex++;
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              });
            }
          }
        },
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                return Center(
                  child: Hero(
                    tag: widget.images[index]["largeImageURL"],
                    child: Image.network(
                      widget.images[index]["largeImageURL"],
                      fit: BoxFit.contain,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 30,
              left: 16,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _navigateBack,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
