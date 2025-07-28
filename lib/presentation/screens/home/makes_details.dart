import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:motors_app/presentation/screens/home/widgets/bmw_car.dart';

class MakesGridScreen extends StatefulWidget {
  const MakesGridScreen({Key? key}) : super(key: key);

  @override
  _MakesGridScreenState createState() => _MakesGridScreenState();
}

class _MakesGridScreenState extends State<MakesGridScreen> {
  List<dynamic> makes = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadMakesData();
  }

  Future<void> _loadMakesData() async {
    try {
      final data = await fetchMainPageData();
      setState(() {
        makes = data['make'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load makes. Please try again.';
      });
    }
  }

  Future<Map<String, dynamic>> fetchMainPageData() async {
    final response = await http.get(
      Uri.parse('https://wheelers.pk/wp-json/stm-mra/v1/filter'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load main page data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        
        title: const Text('Car Makes', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white, // Optional: set background color
        elevation: 3, // Optional: remove shadow
        iconTheme: const IconThemeData(color: Colors.black), // Set icon color
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xff3ec745),))
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : _buildMakeGrid(),
    );
  }

  Widget _buildMakeGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          childAspectRatio: 1,
        ),
        itemCount: makes.length,
        itemBuilder: (context, index) {
          final make = makes[index];
          return _buildMakeGridItem(make['label'], make['logo']);
        },
      ),
    );
  }

  Widget _buildMakeGridItem(String name, String imageUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BMWListScreen(makeName: name),
          ),
        );
      },
      child: Column(
        children: [
          const SizedBox(height: 6),
          Container(
            width: 90,
            height: 90,
            padding: const EdgeInsets.all(1),
           
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) =>
                  const Icon(Icons.directions_car, size: 32),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.directions_car, size: 32),
            ),
          ),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
