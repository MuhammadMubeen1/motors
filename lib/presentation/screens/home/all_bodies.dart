import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:motors_app/presentation/screens/home/browsbybody.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Body Types',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CarBodyTypesScreen(),
    );
  }
}

class CarBodyTypesScreen extends StatefulWidget {
  const CarBodyTypesScreen({super.key});

  @override
  State<CarBodyTypesScreen> createState() => _CarBodyTypesScreenState();
}

class _CarBodyTypesScreenState extends State<CarBodyTypesScreen> {
  List<dynamic> bodyTypes = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchBodyTypes();
  }

  Future<void> fetchBodyTypes() async {
    try {
      final response = await http.get(
        Uri.parse('https://wheelers.pk/wp-json/stm-mra/v1/add-car'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['step_two'] != null && data['step_two']['body'] != null) {
          setState(() {
            bodyTypes = data['step_two']['body'];
            isLoading = false;
          });
        } else {
          throw Exception('Body types data not found in API response');
        }
      } else {
        throw Exception('Failed to load body types: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
   
 
      appBar: AppBar(
        title: const Text('Car Body Types', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBodyContent(),
    );
  }

  Widget _buildBodyContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $errorMessage'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchBodyTypes,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (bodyTypes.isEmpty) {
      return const Center(child: Text('No body types available'));
    }

    return _buildBodyTypeGrid();
  }

  Widget _buildBodyTypeGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: bodyTypes.length,
      itemBuilder: (context, index) {
        return _buildBodyGridItem(bodyTypes[index]);
      },
    );
  }

  Widget _buildBodyGridItem(Map<String, dynamic> bodyType) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BrowseByBody(
              makeName: bodyType['slug'] ?? '',
            ),
          ),
        );
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
            
              padding: const EdgeInsets.all(12),
              child: CachedNetworkImage(
                imageUrl: bodyType['logo'] ?? 'https://via.placeholder.com/150',
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    const Icon(Icons.directions_car, size: 32),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.directions_car, size: 32),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            bodyType['label'] ?? 'Body Type',
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

    