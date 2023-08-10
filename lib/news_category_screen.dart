import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsCategoryScreen extends StatefulWidget {
  @override
  _NewsCategoryScreenState createState() => _NewsCategoryScreenState();
}

class _NewsCategoryScreenState extends State<NewsCategoryScreen> {
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final apiKey = '6ba0cc4f0ff04deab22482f4b0ef3118';
    final response = await http
        .get(Uri.parse('https://newsapi.org/v2/sources?apiKey=$apiKey'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<String> categoriesList = [];
      for (var source in jsonData['sources']) {
        String category = source['category'];
        if (!categoriesList.contains(category)) {
          categoriesList.add(category);
        }
      }
      setState(() {
        categories = categoriesList;
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: const BoxDecoration(
              color: Color(0xff3c096c),
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  color: Color(0x39000000),
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24, 40, 0, 0),
                  child: Row(children: [
                    Text(
                      'NewsOn',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ]),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24, 30, 24, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Welcome!',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w800,
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24, 10, 24, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Find your updated news here',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff9d4edd),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w300,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: categories.map((category) {
                String imageUrl = '';

                switch (category.toLowerCase()) {
                  case 'general':
                    imageUrl =
                        'https://images.unsplash.com/photo-1516251193007-45ef944ab0c6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8c29jaWFsfGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60';
                    break;
                  case 'sports':
                    imageUrl =
                        'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8c3BvcnRzfGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60';
                    break;
                  case 'technology':
                    imageUrl =
                        'https://images.unsplash.com/photo-1518770660439-4636190af475?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8dGVjaG5vbG9neXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60';
                    break;
                  case 'business':
                    imageUrl =
                        'https://images.unsplash.com/photo-1522071820081-009f0129c71c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fG1lZXRpbmd8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60';
                    break;
                  case 'science':
                    imageUrl =
                        'https://images.unsplash.com/photo-1532187863486-abf9dbad1b69?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fHNjaWVuY2V8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60';
                    break;
                  case 'entertainment':
                    imageUrl =
                        'https://images.unsplash.com/photo-1603190287605-e6ade32fa852?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8ZW50ZXJ0YWlubWVudHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60';
                    break;
                  case 'health':
                    imageUrl =
                        'https://images.unsplash.com/photo-1535914254981-b5012eebbd15?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTd8fGhlYWx0aHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60';
                    break;
                  // Tambahkan kategori lain dan URL gambar di sini
                }

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/articles',
                            arguments: category);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 400,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                topLeft: Radius.circular(8),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit
                                    .fill, // Memenuhi seluruh area container
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Text(
                              category,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
